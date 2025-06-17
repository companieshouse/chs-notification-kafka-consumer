resource "aws_instance" "zookeepers" {
  for_each = local.instance_definitions

  ami                    = data.aws_ami.zookeepers[each.value.ami_version_pattern].id
  instance_type          = each.value.instance_type
  key_name               = var.ssh_keyname
  subnet_id              = var.subnets[each.value.availability_zone].id
  user_data_base64       = data.cloudinit_config.zookeepers[each.key].rendered
  vpc_security_group_ids = [aws_security_group.zookeeper.id]

  root_block_device {
    volume_size = var.root_volume_size_gib
  }

  dynamic "ebs_block_device" {
    for_each = local.ami_lvm_block_devices[each.value.ami_version_pattern]
    iterator = block_device

    content {
      device_name = block_device.value.device_name
      encrypted   = block_device.value.ebs.encrypted
      iops        = block_device.value.ebs.iops
      snapshot_id = block_device.value.ebs.snapshot_id
      volume_size = var.lvm_block_definitions[index(var.lvm_block_definitions.*.lvm_physical_volume_device_node, block_device.value.device_name)].aws_volume_size_gb
      volume_type = block_device.value.ebs.volume_type
    }
  }

  tags = {
    Environment     = var.environment
    HostName        = each.value.hostname
    Name            = each.value.name
    Service         = var.service
    ServiceSubType  = var.service_sub_type
  }

}
