locals {

  # ----------------------------------------------------------------------------

  ami_lvm_block_devices = {
    for pattern, ami in data.aws_ami.zookeepers : pattern => [
      for block_device in ami.block_device_mappings : block_device
        if block_device.device_name != ami.root_device_name
    ]
  }

  ami_root_block_devices = {
    for pattern, ami in data.aws_ami.zookeepers : pattern =>
      tolist(ami.block_device_mappings)[index(
        ami.block_device_mappings.*.device_name,
        ami.root_device_name)
      ]
  }

  instance_definitions = merge([
    for availability_zone, instances in var.instance_specifications : {
      for id, specification in instances : id => {
        ami_version_pattern = lookup(specification, "ami_version_pattern", var.default_ami_version_pattern)
        availability_zone   = availability_zone
        hostname            = "${var.service}-${var.environment}-zookeeper-${id}.${var.dns_zone_name}"
        instance_type       = lookup(specification, "instance_type", var.default_instance_type)
        name                = "${var.service}-${var.environment}-zookeeper-${id}"
      }
    }
  ]...)

  specification_ami_version_patterns = toset(
    concat(flatten([
      for availability_zone, instances in var.instance_specifications : [
        for id, specification in instances : specification.ami_version_pattern
          if contains(keys(specification), "ami_version_pattern")
      ]]),
      [var.default_ami_version_pattern]
    )
  )

  start_service = var.route53_available

  # ----------------------------------------------------------------------------

  instance_hostnames = values(local.instance_definitions).*.hostname

  manual_dns_entries = var.route53_available ? [] : [
    for id, definition in local.instance_definitions :
      "${definition.hostname} -> ${aws_instance.zookeepers[id].private_ip}"
  ]

  ensemble = length(local.instance_hostnames) > 1 ? [
    for hostname in local.instance_hostnames :
      "server.${index(local.instance_hostnames, hostname) + 1}=${hostname}:${var.zookeeper_peer_port}:${var.zookeeper_election_port}"
  ] : []

  # ----------------------------------------------------------------------------

  debug = {
    instance_definitions = local.instance_definitions
  }

  manual_steps = {
    dns_entries = local.manual_dns_entries
  }

}
