locals {
  standby_instances_total_check_time     = tonumber(var.in_standby_evaluation_periods) * tonumber(var.in_standby_statistic_period)
  terminating_instances_total_check_time = tonumber(var.in_terminating_evaluation_periods) * tonumber(var.in_terminating_statistic_period)
  total_instances_total_check_time       = tonumber(var.total_instances_evaluation_periods) * tonumber(var.total_instances_statistic_period)

  tags = merge(var.tags, {
    "Terraform" : "true"
    }
  )
}

# HealthyHostCount - AutoScalingGroupName
resource "aws_cloudwatch_metric_alarm" "healthy_instances" {

  alarm_name          = "${var.prefix}-${var.autoscaling_group_name}-instances-in-service"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = var.in_service_evaluation_periods
  metric_name         = "GroupInServiceInstances"
  namespace           = "AWS/AutoScaling"
  period              = var.in_service_statistic_period
  statistic           = "Maximum"
  threshold           = var.expected_instances_in_service
  alarm_description   = format("Healthy host count is less than %s", var.expected_instances_in_service)
  alarm_actions       = var.actions_alarm
  ok_actions          = var.actions_ok
  insufficient_data_actions = var.actions_insufficient


  dimensions = {
    "AutoScalingGroupName" = var.autoscaling_group_name
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

# PendingHostCount - AutoScalingGroupName
resource "aws_cloudwatch_metric_alarm" "pending_instances" {

  alarm_name          = "${var.prefix}-${var.autoscaling_group_name}-instances-in-pending"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.in_pending_evaluation_periods
  metric_name         = "GroupPendingInstances"
  namespace           = "AWS/AutoScaling"
  period              = var.in_pending_statistic_period
  statistic           = "Maximum"
  threshold           = "0"
  alarm_description   = format("Pending host count is greater than 0 for %d seconds", local.standby_instances_total_check_time)
  alarm_actions       = var.actions_alarm
  ok_actions          = var.actions_ok
  insufficient_data_actions = var.actions_insufficient

  dimensions = {
    "AutoScalingGroupName" = var.autoscaling_group_name
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

# StandbyHostCount - AutoScalingGroupName
resource "aws_cloudwatch_metric_alarm" "standby_instances" {

  alarm_name          = "${var.prefix}-${var.autoscaling_group_name}-instances-in-standby"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.in_standby_evaluation_periods
  metric_name         = "GroupStandbyInstances"
  namespace           = "AWS/AutoScaling"
  period              = var.in_standby_statistic_period
  statistic           = "Maximum"
  threshold           = "0"
  alarm_description   = format("Standby host count is greater than 0 for %d seconds", local.standby_instances_total_check_time)
  alarm_actions       = var.actions_alarm
  ok_actions          = var.actions_ok
  insufficient_data_actions = var.actions_insufficient

  dimensions = {
    "AutoScalingGroupName" = var.autoscaling_group_name
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

# TerminatingHostCount - AutoScalingGroupName
resource "aws_cloudwatch_metric_alarm" "terminating_instances" {

  alarm_name          = "${var.prefix}-${var.autoscaling_group_name}-instances-terminating"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = var.in_terminating_evaluation_periods
  metric_name         = "GroupTerminatingInstances"
  namespace           = "AWS/AutoScaling"
  period              = var.in_terminating_statistic_period
  statistic           = "Maximum"
  threshold           = "0"
  alarm_description   = format("Terminating host count is greater than 0 for %d seconds", local.terminating_instances_total_check_time)
  alarm_actions       = var.actions_alarm
  ok_actions          = var.actions_ok
  insufficient_data_actions = var.actions_insufficient

  dimensions = {
    "AutoScalingGroupName" = var.autoscaling_group_name
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

# TotalHostCount - AutoScalingGroupName
resource "aws_cloudwatch_metric_alarm" "total_instances_lower" {

  alarm_name          = "${var.prefix}-${var.autoscaling_group_name}-instances-total-less"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = var.total_instances_evaluation_periods
  metric_name         = "GroupTotalInstances"
  namespace           = "AWS/AutoScaling"
  period              = var.total_instances_statistic_period
  statistic           = "Maximum"
  threshold           = var.total_instances_in_service
  alarm_description   = format("Total host count is less than %s for %d seconds", var.total_instances_in_service, local.total_instances_total_check_time)
  alarm_actions       = var.actions_alarm
  ok_actions          = var.actions_ok
  insufficient_data_actions = var.actions_insufficient

  dimensions = {
    "AutoScalingGroupName" = var.autoscaling_group_name
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

# TotalHostCount - AutoScalingGroupName
resource "aws_cloudwatch_metric_alarm" "total_instances_greater" {

  alarm_name          = "${var.prefix}-${var.autoscaling_group_name}-instances-total-greater"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.total_instances_evaluation_periods
  metric_name         = "GroupTotalInstances"
  namespace           = "AWS/AutoScaling"
  period              = var.total_instances_statistic_period
  statistic           = "Maximum"
  threshold           = var.total_instances_in_service
  alarm_description   = format("Total host count is greater than %s for %d seconds", var.total_instances_in_service, local.total_instances_total_check_time)
  alarm_actions       = var.actions_alarm
  ok_actions          = var.actions_ok
  insufficient_data_actions = var.actions_insufficient

  dimensions = {
    "AutoScalingGroupName" = var.autoscaling_group_name
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
