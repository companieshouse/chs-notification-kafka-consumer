locals {
  tags = merge(var.tags, {
    "Terraform" : "true"
    }
  )
}

# UnHealthyHostCount - TargetGroup, LoadBalancer
resource "aws_cloudwatch_metric_alarm" "unhealthy_hosts" {
  count = length(var.target_group_arn_suffixes) > 0 ? length(var.target_group_arn_suffixes) : 0

  alarm_name          = "${var.prefix}alb-tg-${var.target_group_arn_suffixes[count.index]}-unhealthy-hosts"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.evaluation_periods
  metric_name         = "UnHealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = var.statistic_period
  statistic           = "Maximum"
  threshold           = var.unhealthy_hosts_threshold
  alarm_description   = format("Unhealthy host count is greater than %s", var.unhealthy_hosts_threshold)
  alarm_actions       = var.actions_alarm
  ok_actions          = var.actions_ok
  insufficient_data_actions = var.actions_insufficient
  treat_missing_data  = "notBreaching"

  dimensions = {
    "TargetGroup"  = var.target_group_arn_suffixes[count.index]
    "LoadBalancer" = var.alb_arn_suffix
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

# HTTPCode_Target_4XX_Count - TargetGroup, LoadBalancer
resource "aws_cloudwatch_metric_alarm" "httpcode_target_4xx_count" {
  count = length(var.target_group_arn_suffixes) > 0 ? length(var.target_group_arn_suffixes) : 0

  alarm_name          = "${var.prefix}alb-tg-${var.target_group_arn_suffixes[count.index]}-high4XXCount"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.evaluation_periods
  metric_name         = "HTTPCode_Target_4XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = var.statistic_period
  statistic           = "Sum"
  threshold           = var.maximum_4xx_threshold
  alarm_description   = "Average API 4XX target group error code count is too high"
  alarm_actions       = var.actions_alarm
  ok_actions          = var.actions_ok
  insufficient_data_actions = var.actions_insufficient
  treat_missing_data  = "notBreaching"

  dimensions = {
    "TargetGroup"  = var.target_group_arn_suffixes[count.index]
    "LoadBalancer" = var.alb_arn_suffix
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

# HTTPCode_Target_5XX_Count - LoadBalancer
resource "aws_cloudwatch_metric_alarm" "httpcode_lb_4xx_count" {
  alarm_name          = "${var.prefix}alb-${var.alb_arn_suffix}-high4XXCount"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.evaluation_periods
  metric_name         = "HTTPCode_ELB_4XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = var.statistic_period
  statistic           = "Sum"
  threshold           = var.maximum_4xx_threshold
  alarm_description   = "Average API 4XX load balancer error code count is too high"
  alarm_actions       = var.actions_alarm
  ok_actions          = var.actions_ok
  insufficient_data_actions = var.actions_insufficient
  treat_missing_data  = "notBreaching"

  dimensions = {
    "LoadBalancer" = var.alb_arn_suffix
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

# HTTPCode_Target_5XX_Count - TargetGroup, LoadBalancer
resource "aws_cloudwatch_metric_alarm" "httpcode_target_5xx_count" {
  count = length(var.target_group_arn_suffixes) > 0 ? length(var.target_group_arn_suffixes) : 0

  alarm_name          = "${var.prefix}alb-tg-${var.target_group_arn_suffixes[count.index]}-high5XXCount"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.evaluation_periods
  metric_name         = "HTTPCode_Target_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = var.statistic_period
  statistic           = "Sum"
  threshold           = var.maximum_5xx_threshold
  alarm_description   = "Average API 5XX target group error code count is too high"
  alarm_actions       = var.actions_alarm
  ok_actions          = var.actions_ok
  insufficient_data_actions = var.actions_insufficient
  treat_missing_data  = "notBreaching"

  dimensions = {
    "TargetGroup"  = var.target_group_arn_suffixes[count.index]
    "LoadBalancer" = var.alb_arn_suffix
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

# HTTPCode_Target_5XX_Count - LoadBalancer
resource "aws_cloudwatch_metric_alarm" "httpcode_lb_5xx_count" {
  alarm_name          = "${var.prefix}alb-${var.alb_arn_suffix}-high5XXCount"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.evaluation_periods
  metric_name         = "HTTPCode_ELB_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = var.statistic_period
  statistic           = "Sum"
  threshold           = var.maximum_5xx_threshold
  alarm_description   = "Average API 5XX load balancer error code count is too high"
  alarm_actions       = var.actions_alarm
  ok_actions          = var.actions_ok
  insufficient_data_actions = var.actions_insufficient
  treat_missing_data  = "notBreaching"

  dimensions = {
    "LoadBalancer" = var.alb_arn_suffix
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

# TargetResponseTime - TargetGroup, AvailabilityZone, LoadBalancer
resource "aws_cloudwatch_metric_alarm" "target_response_time_average" {
  count = length(var.target_group_arn_suffixes) > 0 ? length(var.target_group_arn_suffixes) : 0

  alarm_name          = "${var.prefix}alb-tg-${var.target_group_arn_suffixes[count.index]}-highResponseTime"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.evaluation_periods
  metric_name         = "TargetResponseTime"
  namespace           = "AWS/ApplicationELB"
  period              = var.statistic_period
  statistic           = "Average"
  threshold           = var.response_time_threshold
  alarm_description   = format("Average API response time is greater than %s", var.response_time_threshold)
  alarm_actions       = var.actions_alarm
  ok_actions          = var.actions_ok
  insufficient_data_actions = var.actions_insufficient
  treat_missing_data  = "notBreaching"

  dimensions = {
    "TargetGroup"  = var.target_group_arn_suffixes[count.index]
    "LoadBalancer" = var.alb_arn_suffix
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

# TLS Negotiation Errors - ClientTLSNegotiationErrorCount - LoadBalancer
resource "aws_cloudwatch_metric_alarm" "client_tls_neg_err_count" {
  alarm_name                = "${var.prefix}alb-${var.alb_arn_suffix}-clientTLSErrorCount"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = var.evaluation_periods
  metric_name               = "ClientTLSNegotiationErrorCount"
  namespace                 = "AWS/ApplicationELB"
  period                    = var.statistic_period
  statistic                 = "Sum"
  threshold                 = var.tls_negotiation_threshold
  alarm_description         = format("Total TLS Negotiation errors on %s is greater than %s", var.alb_arn_suffix, var.response_time_threshold)
  alarm_actions             = var.actions_alarm
  ok_actions                = var.actions_ok
  insufficient_data_actions = var.actions_insufficient
  treat_missing_data        = "notBreaching"

  dimensions = {
    "LoadBalancer" = var.alb_arn_suffix
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
