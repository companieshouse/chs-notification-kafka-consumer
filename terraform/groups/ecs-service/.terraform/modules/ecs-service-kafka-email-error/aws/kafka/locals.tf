locals {

  # ----------------------------------------------------------------------------

  ami_lvm_block_devices = {
    for pattern, ami in data.aws_ami.kafkas : pattern => [
      for block_device in ami.block_device_mappings : block_device
        if block_device.device_name != ami.root_device_name
    ]
  }

  ami_root_block_devices = {
    for pattern, ami in data.aws_ami.kafkas : pattern =>
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
        hostname            = "${var.service}-${var.environment}-kafka-${id}.${var.dns_zone_name}"
        instance_type       = lookup(specification, "instance_type", var.default_instance_type)
        name                = "${var.service}-${var.environment}-kafka-${id}"
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
  
  instance_template_path = var.instance_template_path == null ? local.template_path : var.instance_template_path
  template_path = "${path.module}/cloud-init/templates"

  update_nameserver = !var.route53_available

  # ----------------------------------------------------------------------------

  debug = {
    instance_definitions = local.instance_definitions
  }

  manual_steps = {}

}
