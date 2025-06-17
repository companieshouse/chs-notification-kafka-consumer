data "aws_ami" "kafkas" {
  for_each = local.specification_ami_version_patterns

  owners      = [var.ami_owner_id]
  most_recent = true
  name_regex  = "^kafka-ami-${each.value}$"

  filter {
    name   = "name"
    values = ["kafka-ami-*"]
  }
}

data "aws_route53_zone" "zone" {
  count        = var.route53_available ? 1 : 0

  name         = var.dns_zone_name
  private_zone = false
}

data "cloudinit_config" "kafkas" {
  for_each = local.instance_definitions

  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content = templatefile(fileexists("${local.instance_template_path}/${each.key}/bootstrap-commands.yml.tpl") ? "${local.instance_template_path}/${each.key}/bootstrap-commands.yml.tpl" : "${local.template_path}/bootstrap-commands.yml.tpl", {
      lvm_block_definitions   = var.lvm_block_definitions
      root_volume_device_node = data.aws_ami.kafkas[each.value.ami_version_pattern].root_device_name
      update_nameserver       = local.update_nameserver
    })
    merge_type = var.user_data_merge_strategy
  }

  part {
    content_type = "text/cloud-config"
    content = templatefile(fileexists("${local.instance_template_path}/${each.key}/kafka.service.tpl") ? "${local.instance_template_path}/${each.key}/kafka.service.tpl" : "${local.template_path}/kafka.service.tpl", {
      kafka_home          = var.kafka_home
      kafka_service_group = var.kafka_service_group
      kafka_service_user  = var.kafka_service_user
    })
    merge_type = var.user_data_merge_strategy
  }

  part {
    content_type = "text/cloud-config"
    content = templatefile(fileexists("${local.instance_template_path}/${each.key}/ns-update-key.tpl") ? "${local.instance_template_path}/${each.key}/ns-update-key.tpl" : "${local.template_path}/ns-update-key.tpl", {
      key_content = var.ns_update_key_content
      key_path    = var.ns_update_key_path
    })
    merge_type = var.user_data_merge_strategy
  }

  part {
    content_type = "text/cloud-config"
    content = templatefile(fileexists("${local.instance_template_path}/${each.key}/ns-update.sh.tpl") ? "${local.instance_template_path}/${each.key}/ns-update.sh.tpl" : "${local.template_path}/ns-update.sh.tpl", {
      aws_instance_metadata_url = var.aws_instance_metadata_url
      dns_server_ip             = var.dns_server_ip
      dns_zone_name             = var.dns_zone_name
      hostname                  = each.value.hostname
      key_path                  = var.ns_update_key_path
    })
    merge_type = var.user_data_merge_strategy
  }

  part {
    content_type = "text/cloud-config"
    content = templatefile(fileexists("${local.instance_template_path}/${each.key}/server.properties.tpl") ? "${local.instance_template_path}/${each.key}/server.properties.tpl" : "${local.template_path}/server.properties.tpl", {
      broker_id                         = each.key
      hostname                          = each.value.hostname
      kafka_data_directory              = var.kafka_data_directory
      kafka_home                        = var.kafka_home
      kafka_service_group               = var.kafka_service_group
      kafka_service_user                = var.kafka_service_user
      kafka_zookeeper_connect_string    = var.kafka_zookeeper_connect_string
      min_insync_replicas               = var.kafka_min_insync_replicas
      offsets_topic_replication_factor  = var.kafka_offsets_topic_replication_factor
      rack_id                           = each.value.availability_zone
    })
    merge_type = var.user_data_merge_strategy
  }

}
