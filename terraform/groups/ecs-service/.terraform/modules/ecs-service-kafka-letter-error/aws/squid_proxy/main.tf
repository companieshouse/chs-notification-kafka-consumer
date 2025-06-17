resource "aws_launch_template" "this" {
  name_prefix   = "ltmp-${var.name}"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  iam_instance_profile {
    arn = aws_iam_instance_profile.this.arn
  }
  vpc_security_group_ids = [aws_security_group.this.id]
  user_data              = var.userdata_template_custom != null ? base64encode(var.userdata_template_custom) : local.userdata_template_builtin

  monitoring {
    enabled = true
  }

  lifecycle {
    create_before_destroy = true
  }
  tags = local.tags
}

#Create an AutoScaling group per AZ/Proxy subnet
resource "aws_autoscaling_group" "this" {
  count = length(var.private_subnet_ids)

  name                      = format("asg-%s-%s", var.name, substr(local.subnet_az_map[var.private_subnet_ids[count.index]], -2, 0))
  max_size                  = 1
  min_size                  = 1
  health_check_grace_period = var.asg_health_check_grace_period
  health_check_type         = "EC2"

  vpc_zone_identifier = [var.private_subnet_ids[count.index]]

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  timeouts {
    delete = "15m"
  }

  dynamic "tag" {
    for_each = local.tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  tag {
    # Add Name to each deployed Squid instance with the relevant one in the name
    key                 = "Name"
    value               = format("%s-%s", var.name, substr(local.subnet_az_map[var.private_subnet_ids[count.index]], -2, 0))
    propagate_at_launch = true
  }

  tag {
    # Add route table identifier to autoscaling group tags, this is used to identify which route table needs updated from ASG instance alarms 
    key                 = "RouteTableIds"
    value               = var.ingress_route_table_ids[count.index]
    propagate_at_launch = false
  }
}

resource "aws_autoscaling_lifecycle_hook" "this" {
  count = length(var.private_subnet_ids)

  name                   = format("asgh-%s-%s", var.name, substr(local.subnet_az_map[var.private_subnet_ids[count.index]], -2, 0))
  autoscaling_group_name = aws_autoscaling_group.this[count.index].name
  default_result         = "ABANDON"
  heartbeat_timeout      = 300
  lifecycle_transition   = "autoscaling:EC2_INSTANCE_LAUNCHING"
}
