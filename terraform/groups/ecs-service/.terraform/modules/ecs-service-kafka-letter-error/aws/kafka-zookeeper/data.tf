data "aws_ami" "kafka_zookeepers" {
  for_each = local.specification_ami_version_patterns

  owners      = [var.ami_owner_id]
  most_recent = true
  name_regex  = "^kafka-zookeeper-ami-${each.value}$"

  filter {
    name   = "name"
    values = ["kafka-zookeeper-ami-*"]
  }
}

data "aws_route53_zone" "zone" {
  count        = var.route53_available ? 1 : 0

  name         = var.dns_zone_name
  private_zone = false
}

data "cloudinit_config" "kafka_zookeepers" {
  for_each = local.instance_definitions

  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content = templatefile(fileexists("${local.instance_template_path}/${each.key}/application.conf.tpl") ? "${local.instance_template_path}/${each.key}/application.conf.tpl" : "${local.template_path}/application.conf.tpl", {
      basic_authentication      = var.cmak_basic_authentication
      cmak_home                 = var.cmak_home
      feature_list              = join(",", formatlist("\"%s\"", var.cmak_feature_list))
      service_group             = var.cmak_service_group
      service_user              = var.cmak_service_user
      zookeeper_connect_string  = var.cmak_zookeeper_connect_string
    })
    merge_type = var.user_data_merge_strategy
  }

  part {
    content_type = "text/cloud-config"
    content = templatefile(fileexists("${local.instance_template_path}/${each.key}/bootstrap-commands.yml.tpl") ? "${local.instance_template_path}/${each.key}/bootstrap-commands.yml.tpl" : "${local.template_path}/bootstrap-commands.yml.tpl", {
      lvm_block_definitions   = var.lvm_block_definitions
      root_volume_device_node = data.aws_ami.kafka_zookeepers[each.value.ami_version_pattern].root_device_name
      update_nameserver       = local.update_nameserver
    })
    merge_type = var.user_data_merge_strategy
  }

  part {
    content_type = "text/cloud-config"
    content = templatefile(fileexists("${local.instance_template_path}/${each.key}/myid.tpl") ? "${local.instance_template_path}/${each.key}/myid.tpl" : "${local.template_path}/myid.tpl", {
      myid                      = each.key
      zookeeper_data_directory  = var.zookeeper_data_directory
      zookeeper_service_group   = var.zookeeper_service_group
      zookeeper_service_user    = var.zookeeper_service_user
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
    content = templatefile(fileexists("${local.instance_template_path}/${each.key}/zoo.cfg.tpl") ? "${local.instance_template_path}/${each.key}/zoo.cfg.tpl" : "${local.template_path}/zoo.cfg.tpl", {
      ensemble                            = local.ensemble
      zookeeper_autopurge_interval_hours  = var.zookeeper_autopurge_interval_hours
      zookeeper_client_port               = var.zookeeper_client_port
      zookeeper_data_directory            = var.zookeeper_data_directory
      zookeeper_home                      = var.zookeeper_home
      zookeeper_init_limit_ticks          = var.zookeeper_init_limit_ticks
      zookeeper_service_group             = var.zookeeper_service_group
      zookeeper_service_user              = var.zookeeper_service_user
      zookeeper_snap_count                = var.zookeeper_snap_count
      zookeeper_snapshot_retain_count     = var.zookeeper_snapshot_retain_count
      zookeeper_sync_limit_ticks          = var.zookeeper_sync_limit_ticks
      zookeeper_tick_time                 = var.zookeeper_tick_time
    })
    merge_type = var.user_data_merge_strategy
  }

  part {
    content_type = "text/cloud-config"
    content = templatefile(fileexists("${local.instance_template_path}/${each.key}/zookeeper-env.sh.tpl") ? "${local.instance_template_path}/${each.key}/zookeeper-env.sh.tpl" : "${local.template_path}/zookeeper-env.sh.tpl", {
      zookeeper_heap_mb         = var.zookeeper_heap_mb
      zookeeper_home            = var.zookeeper_home
      zookeeper_service_group   = var.zookeeper_service_group
      zookeeper_service_user    = var.zookeeper_service_user
    })
    merge_type = var.user_data_merge_strategy
  }

  part {
    content_type = "text/cloud-config"
    content = templatefile(fileexists("${local.instance_template_path}/${each.key}/zookeeper.service.tpl") ? "${local.instance_template_path}/${each.key}/zookeeper.service.tpl" : "${local.template_path}/zookeeper.service.tpl", {
      zookeeper_home          = var.zookeeper_home
      zookeeper_service_group = var.zookeeper_service_group
      zookeeper_service_user  = var.zookeeper_service_user
    })
    merge_type = var.user_data_merge_strategy
  }
}
