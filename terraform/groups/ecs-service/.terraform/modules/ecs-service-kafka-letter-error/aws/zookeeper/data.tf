data "aws_ami" "zookeepers" {
  for_each = local.specification_ami_version_patterns

  owners      = [var.ami_owner_id]
  most_recent = true
  name_regex  = "^zookeeper-ami-${each.value}$"

  filter {
    name   = "name"
    values = ["zookeeper-ami-*"]
  }
}

data "aws_route53_zone" "zone" {
  count        = var.route53_available ? 1 : 0

  name         = var.dns_zone_name
  private_zone = false
}

data "cloudinit_config" "zookeepers" {
  for_each = local.instance_definitions

  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/cloud-init/templates/bootstrap-commands.yml.tpl", {
      lvm_block_definitions   = var.lvm_block_definitions
      root_volume_device_node = data.aws_ami.zookeepers[each.value.ami_version_pattern].root_device_name
      start_service           = local.start_service
    })
    merge_type = var.user_data_merge_strategy
  }

  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/cloud-init/templates/myid.tpl", {
      myid                      = each.key
      zookeeper_data_directory  = var.zookeeper_data_directory
      zookeeper_service_group   = var.zookeeper_service_group
      zookeeper_service_user    = var.zookeeper_service_user
    })
    merge_type = var.user_data_merge_strategy
  }

  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/cloud-init/templates/zoo.cfg.tpl", {
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
    content = templatefile("${path.module}/cloud-init/templates/zookeeper-env.sh.tpl", {
      zookeeper_heap_mb         = var.zookeeper_heap_mb
      zookeeper_home            = var.zookeeper_home
      zookeeper_service_group   = var.zookeeper_service_group
      zookeeper_service_user    = var.zookeeper_service_user
    })
    merge_type = var.user_data_merge_strategy
  }

  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/cloud-init/templates/zookeeper.service.tpl", {
      zookeeper_home          = var.zookeeper_home
      zookeeper_service_group = var.zookeeper_service_group
      zookeeper_service_user  = var.zookeeper_service_user
    })
    merge_type = var.user_data_merge_strategy
  }
}
