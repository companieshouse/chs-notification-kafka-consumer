locals {
  tags = merge(var.tags, {
    "Terraform" : "true"
    }
  )

  status_composite_rule = <<EOF
ALARM(${aws_cloudwatch_metric_alarm.ec2_overallstatus_check.alarm_name}) AND
ALARM(${aws_cloudwatch_metric_alarm.ec2_systemstatus_check.alarm_name}) AND
ALARM(${aws_cloudwatch_metric_alarm.ec2_instancestatus_check.alarm_name})
EOF
}

resource "aws_cloudwatch_metric_alarm" "ec2_cpuutilization" {
  alarm_name                = "${var.name_prefix}-EC2-CPUUtilization-High-${var.instance_id}"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = var.cpuutilization_evaluation_periods
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = var.cpuutilization_statistics_period
  statistic                 = "Average"
  threshold                 = var.cpuutilization_threshold
  alarm_actions             = var.alarm_actions
  ok_actions                = var.ok_actions
  insufficient_data_actions = var.insufficient_data_actions
  alarm_description         = "This alarm will trigger for high CPU utilization of the instance: ${var.instance_id}."

  dimensions = {
    InstanceId = var.instance_id
  }

  tags = local.tags

  lifecycle {
    ignore_changes = [
      alarm_actions,
      ok_actions,
      insufficient_data_actions
    ]
  }
}

resource "aws_cloudwatch_metric_alarm" "ec2_overallstatus_check" {
  alarm_name                = "${var.name_prefix}-EC2-OverallStatus-Failed-${var.instance_id}"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = var.status_evaluation_periods
  metric_name               = "StatusCheckFailed"
  namespace                 = "AWS/EC2"
  period                    = var.status_statistics_period
  statistic                 = "Maximum"
  threshold                 = "1"
  alarm_actions             = var.alarm_actions
  ok_actions                = var.ok_actions
  insufficient_data_actions = var.insufficient_data_actions
  alarm_description         = "This alarm will trigger when the the overall status of the instance: ${var.instance_id} is failed."

  dimensions = {
    InstanceId = var.instance_id
  }

  tags = local.tags

  lifecycle {
    ignore_changes = [
      alarm_actions,
      ok_actions,
      insufficient_data_actions
    ]
  }
}

resource "aws_cloudwatch_metric_alarm" "ec2_systemstatus_check" {
  alarm_name                = "${var.name_prefix}-EC2-SystemStatus-Failed-${var.instance_id}"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = var.status_evaluation_periods
  metric_name               = "StatusCheckFailed_System"
  namespace                 = "AWS/EC2"
  period                    = var.status_statistics_period
  statistic                 = "Maximum"
  threshold                 = "1"
  alarm_actions             = var.alarm_actions
  ok_actions                = var.ok_actions
  insufficient_data_actions = var.insufficient_data_actions
  alarm_description         = "This alarm will trigger when the status of underlying AWS host for: ${var.instance_id} is failed."

  dimensions = {
    InstanceId = var.instance_id
  }

  tags = local.tags

  lifecycle {
    ignore_changes = [
      alarm_actions,
      ok_actions,
      insufficient_data_actions
    ]
  }
}

resource "aws_cloudwatch_metric_alarm" "ec2_instancestatus_check" {
  alarm_name                = "${var.name_prefix}-EC2-InstanceStatus-Failed-${var.instance_id}"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = var.status_evaluation_periods
  metric_name               = "StatusCheckFailed_Instance"
  namespace                 = "AWS/EC2"
  period                    = var.status_statistics_period
  statistic                 = "Maximum"
  threshold                 = "1"
  alarm_actions             = var.alarm_actions
  ok_actions                = var.ok_actions
  insufficient_data_actions = var.insufficient_data_actions
  alarm_description         = "This alarm will trigger when the status of the Instance: ${var.instance_id} is failed at a network level, kernel panics will also cause this to trigger"

  dimensions = {
    InstanceId = var.instance_id
  }

  tags = local.tags

  lifecycle {
    ignore_changes = [
      alarm_actions,
      ok_actions,
      insufficient_data_actions
    ]
  }
}

resource "aws_cloudwatch_composite_alarm" "ec2_composite_status" {
  alarm_name        = "${var.name_prefix}-EC2-StatusAlarmCheck-${var.instance_id}"
  alarm_description = "This alarm will trigger when all 3 status alarms have triggered as this is likely an offline EC2 instance."

  alarm_actions             = var.alarm_actions
  ok_actions                = var.ok_actions
  insufficient_data_actions = var.insufficient_data_actions

  alarm_rule = trimspace(replace(local.status_composite_rule, "/\n+/", " "))

  depends_on = [
    aws_cloudwatch_metric_alarm.ec2_overallstatus_check,
    aws_cloudwatch_metric_alarm.ec2_systemstatus_check,
    aws_cloudwatch_metric_alarm.ec2_instancestatus_check
  ]

  lifecycle {
    ignore_changes = [
      alarm_actions,
      ok_actions,
      insufficient_data_actions
    ]
  }
}

resource "aws_cloudwatch_metric_alarm" "ec2_instance_availablememory_low" {
  count = var.enable_memory_alarms ? 1 : 0

  alarm_name                = "${var.name_prefix}-EC2-AvailableMemory-Low-${var.instance_id}"
  comparison_operator       = "LessThanOrEqualToThreshold"
  evaluation_periods        = var.memory_evaluation_periods
  metric_name               = "mem_available_percent"
  namespace                 = var.namespace
  period                    = var.memory_statistics_period
  statistic                 = "Minimum"
  threshold                 = var.available_memory_threshold
  alarm_actions             = var.alarm_actions
  ok_actions                = var.ok_actions
  insufficient_data_actions = var.insufficient_data_actions
  alarm_description         = "This alarm will trigger when the % of available memory drops below ${var.available_memory_threshold} on InstanceId: ${var.instance_id}"
  treat_missing_data        = "notBreaching"

  dimensions = {
    InstanceId = var.instance_id
  }

  tags = local.tags

  lifecycle {
    ignore_changes = [
      alarm_actions,
      ok_actions,
      insufficient_data_actions
    ]
  }
}

resource "aws_cloudwatch_metric_alarm" "ec2_instance_usedmemory_high" {
  count = var.enable_memory_alarms ? 1 : 0

  alarm_name                = "${var.name_prefix}-EC2-UsedMemory-High-${var.instance_id}"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = var.memory_evaluation_periods
  metric_name               = "mem_used_percent"
  namespace                 = var.namespace
  period                    = var.memory_statistics_period
  statistic                 = "Maximum"
  threshold                 = var.used_memory_threshold
  alarm_actions             = var.alarm_actions
  ok_actions                = var.ok_actions
  insufficient_data_actions = var.insufficient_data_actions
  alarm_description         = "This alarm will trigger when the % of used memory is above ${var.used_memory_threshold} on InstanceId: ${var.instance_id}"
  treat_missing_data        = "notBreaching"

  dimensions = {
    InstanceId = var.instance_id
  }

  tags = local.tags

  lifecycle {
    ignore_changes = [
      alarm_actions,
      ok_actions,
      insufficient_data_actions
    ]
  }
}

resource "aws_cloudwatch_metric_alarm" "ec2_instance_swapmemory_low" {
  count = var.enable_memory_alarms ? 1 : 0

  alarm_name                = "${var.name_prefix}-EC2-SwapMemory-Low-${var.instance_id}"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = var.memory_evaluation_periods
  metric_name               = "swap_used_percent"
  namespace                 = var.namespace
  period                    = var.memory_statistics_period
  statistic                 = "Maximum"
  threshold                 = var.used_swap_memory_threshold
  alarm_actions             = var.alarm_actions
  ok_actions                = var.ok_actions
  insufficient_data_actions = var.insufficient_data_actions
  alarm_description         = "This alarm will trigger when the % of used swap memory is above ${var.used_swap_memory_threshold} on InstanceId: ${var.instance_id}"
  treat_missing_data        = "notBreaching"

  dimensions = {
    InstanceId = var.instance_id
  }

  tags = local.tags

  lifecycle {
    ignore_changes = [
      alarm_actions,
      ok_actions,
      insufficient_data_actions
    ]
  }
}

resource "aws_cloudwatch_metric_alarm" "ec2_instancedisks_low_space" {
  for_each = var.enable_disk_alarms ? { for i, v in var.disk_devices : i => v } : {}

  alarm_name                = "${var.name_prefix}-EC2-DiskSpace-Low-${var.instance_id}"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = var.disk_evaluation_periods
  metric_name               = "disk_used_percent"
  namespace                 = var.namespace
  period                    = var.disk_statistics_period
  statistic                 = "Average"
  threshold                 = var.low_disk_threshold
  alarm_description         = "This alarm will trigger when the % of available disk space on ${each.value.instance_device_mount_path} drops below ${var.low_disk_threshold} on InstanceId: ${var.instance_id}"
  alarm_actions             = var.alarm_actions
  ok_actions                = var.ok_actions
  insufficient_data_actions = var.insufficient_data_actions
  treat_missing_data        = "notBreaching"

  dimensions = {
    InstanceId = var.instance_id
    path       = each.value.instance_device_mount_path
    device     = each.value.instance_device_location
    fstype     = each.value.instance_device_fstype
  }

  tags = local.tags

  lifecycle {
    ignore_changes = [
      alarm_actions,
      ok_actions,
      insufficient_data_actions
    ]
  }
}
