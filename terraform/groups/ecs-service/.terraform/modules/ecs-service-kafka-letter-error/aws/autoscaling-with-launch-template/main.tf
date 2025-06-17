#######################
# Launch template
#######################
resource "aws_launch_template" "this" {
  name                   = var.lt_name
  instance_type          = var.instance_type
  image_id               = var.image_id
  key_name               = var.key_name
  ebs_optimized          = var.ebs_optimized
  vpc_security_group_ids = var.security_groups
  user_data              = var.user_data_base64

  dynamic "cpu_options" {
    for_each = var.core_count == 0 ? {} : { custom_core_count = true }
    content {
      core_count       = var.core_count
      threads_per_core = 2
    }
  }

  block_device_mappings {
    device_name = lookup(var.root_block_device[0], "device_name", "/dev/xvda")

    ebs {
      volume_size           = lookup(var.root_block_device[0], "volume_size", null)
      delete_on_termination = lookup(var.root_block_device[0], "delete_on_termination", null)
      encrypted             = lookup(var.root_block_device[0], "encrypted", null)
      kms_key_id            = lookup(var.root_block_device[0], "kms_key_id", null)
      iops                  = lookup(var.root_block_device[0], "iops", null)
      throughput            = lookup(var.root_block_device[0], "throughput", null)
      volume_type           = lookup(var.root_block_device[0], "volume_type", null)
    }
  }

  dynamic "block_device_mappings" { 
    for_each = var.block_device_mappings
    content {
      device_name           = block_device_mappings.value.device_name
      no_device             = lookup(block_device_mappings.value, "no_device", null)

      ebs {
        delete_on_termination = lookup(block_device_mappings.value, "delete_on_termination", null)
        encrypted             = lookup(block_device_mappings.value, "encrypted", null)
        kms_key_id            = lookup(block_device_mappings.value, "kms_key_id", null)
        iops                  = lookup(block_device_mappings.value, "iops", null)
        throughput            = lookup(block_device_mappings.value, "throughput", null)
        snapshot_id           = lookup(block_device_mappings.value, "snapshot_id", null)
        volume_size           = lookup(block_device_mappings.value, "volume_size", null)
        volume_type           = lookup(block_device_mappings.value, "volume_type", null)
      }
    }
  }

  iam_instance_profile {
    name = var.iam_instance_profile
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = var.enforce_imdsv2 ? "required" : "optional"
    instance_metadata_tags      = "enabled"
    http_put_response_hop_limit = var.imdsv2_hop_limit
  }

  monitoring {
    enabled = var.enable_monitoring
  }
}

####################
# Autoscaling group
####################
resource "aws_autoscaling_group" "this" {
  count = 1

  name_prefix = "${var.asg_name}-"
  vpc_zone_identifier  = var.vpc_zone_identifier
  max_size             = var.max_size
  min_size             = var.min_size
  desired_capacity     = var.desired_capacity

  load_balancers            = var.load_balancers
  health_check_grace_period = var.health_check_grace_period
  health_check_type         = var.health_check_type

  min_elb_capacity          = var.min_elb_capacity
  wait_for_elb_capacity     = var.wait_for_elb_capacity
  target_group_arns         = var.target_group_arns
  default_cooldown          = var.default_cooldown
  force_delete              = var.force_delete
  termination_policies      = var.termination_policies
  suspended_processes       = var.suspended_processes
  enabled_metrics           = var.enabled_metrics
  metrics_granularity       = var.metrics_granularity
  wait_for_capacity_timeout = var.wait_for_capacity_timeout
  protect_from_scale_in     = var.protect_from_scale_in
  service_linked_role_arn   = var.service_linked_role_arn
  max_instance_lifetime     = var.max_instance_lifetime

  launch_template {
    id      = aws_launch_template.this.id
    version = aws_launch_template.this.latest_version
  }

  dynamic "instance_refresh" {
    for_each = var.enable_instance_refresh ? [1] : []
    content {
      strategy = "Rolling"
      preferences {
        instance_warmup        = var.refresh_instance_warmup
        min_healthy_percentage = var.refresh_min_healthy_percentage
      }
      triggers = var.refresh_triggers
    }
  }

  dynamic "tag" {
    for_each = local.tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}
