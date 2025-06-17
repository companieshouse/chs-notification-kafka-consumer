// ---- Security Group ----
resource "aws_security_group" "ec2-security-group" {
  name        = "${var.name_prefix}-ec2-sg"
  description = "Allow HTTP, HTTPS, and SSH"
  vpc_id      = var.vpc_id
  tags        = local.default_tags

  // SSH
  ingress {
    description     = "SSH from admin CIDRs"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    prefix_list_ids = [data.aws_ec2_managed_prefix_list.administration.id]
  }

  // ECS Auto-Assigned Host Ports in the linux kernel ephemeral port range used by bridge networking
  ingress {
    description = "ECS Auto-Assigned ports from everywhere"
    from_port   = 32768
    to_port     = 61000
    protocol    = "tcp"
    cidr_blocks = concat([for s in data.aws_subnet.alb_subnets : s.cidr_block], local.additional_ec2_ingress_cidr_blocks)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

// ---- Launch Template ----
resource "aws_launch_template" "ecs_launch_template" {
  name_prefix            = "${var.name_prefix}-"
  image_id               = var.ec2_image_id
  instance_type          = var.ec2_instance_type
  vpc_security_group_ids = [aws_security_group.ec2-security-group.id]
  key_name               = var.ec2_key_pair_name
  user_data              = data.cloudinit_config.userdata_config.rendered
  tags                   = local.default_tags


  iam_instance_profile {
    name = aws_iam_instance_profile.ecs-instance-profile.name
  }

  lifecycle {
    create_before_destroy = true
  }

  block_device_mappings {
    device_name = lookup(var.ec2_root_block_device, "device_name", "/dev/xvda")

    ebs {
      volume_size           = lookup(var.ec2_root_block_device, "volume_size", null)
      delete_on_termination = lookup(var.ec2_root_block_device, "delete_on_termination", null)
      encrypted             = true
      kms_key_id            = aws_kms_key.ec2_ebs.arn
      iops                  = lookup(var.ec2_root_block_device, "iops", null)
      throughput            = lookup(var.ec2_root_block_device, "throughput", null)
      volume_type           = lookup(var.ec2_root_block_device, "volume_type", null)
    }
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = local.metadata_http_tokens
    instance_metadata_tags      = "enabled"
    http_put_response_hop_limit = 2
  }

  tag_specifications {
    resource_type = "instance"
    tags          = local.default_tags
  }
}

//---- Auto Scaling Group ----
resource "aws_autoscaling_group" "ecs-autoscaling-group" {
  name                  = "${var.name_prefix}-ecs-asg"
  max_size              = var.asg_max_instance_count
  min_size              = var.asg_min_instance_count
  desired_capacity      = var.asg_desired_instance_count
  vpc_zone_identifier   = split(",", var.subnet_ids)
  health_check_type     = "ELB"
  protect_from_scale_in = var.enable_asg_autoscaling


  launch_template {
    id      = aws_launch_template.ecs_launch_template.id
    version = aws_launch_template.ecs_launch_template.latest_version
  }

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "${var.name_prefix}-ecs-instance"
    propagate_at_launch = true
  }
  tag {
    key                 = "Environment"
    value               = var.environment
    propagate_at_launch = true
  }
  dynamic "tag" {
    for_each = var.enable_asg_autoscaling ? [""] : []
    content {
      key                 = "AmazonECSManaged"
      value               = true
      propagate_at_launch = true
    }
  }
  dynamic "tag" {
    for_each = local.default_tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}

# ASG scheduled shutdown
resource "aws_autoscaling_schedule" "schedule-scaledown" {
  count = length(var.scaledown_schedule) > 0 ? 1 : 0

  scheduled_action_name  = "${var.name_prefix}-scheduled-scaledown"
  min_size               = 0
  max_size               = 0
  desired_capacity       = 0
  recurrence             = var.scaledown_schedule
  time_zone              = "Europe/London"
  autoscaling_group_name = aws_autoscaling_group.ecs-autoscaling-group.name
}

# ASG scheduled startup
resource "aws_autoscaling_schedule" "schedule-scaleup" {
  count = length(var.scaleup_schedule) > 0 ? 1 : 0

  scheduled_action_name  = "${var.name_prefix}-scheduled-scaleup"
  min_size               = var.asg_min_instance_count
  max_size               = var.asg_max_instance_count
  desired_capacity       = var.asg_desired_instance_count
  recurrence             = var.scaleup_schedule
  time_zone              = "Europe/London"
  autoscaling_group_name = aws_autoscaling_group.ecs-autoscaling-group.name
}
