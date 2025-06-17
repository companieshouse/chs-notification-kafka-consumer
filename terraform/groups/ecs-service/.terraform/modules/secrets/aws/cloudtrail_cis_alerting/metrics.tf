resource "aws_cloudwatch_log_metric_filter" "cloudwatch_metric_filter" {
  for_each = var.metric_filters

  name           = "${var.aws_profile}-${each.key}-filter"
  pattern        = each.value
  log_group_name = var.log_group_name

  metric_transformation {
    name          = each.key
    namespace     = "LogMetrics"
    value         = 1
    default_value = 0
  }
}

resource "aws_cloudwatch_metric_alarm" "cloudwatch_metric_alarm" {
  for_each = var.metric_filters

  alarm_name          = "${var.aws_profile}-${each.key}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = each.key
  namespace           = "LogMetrics"
  period              = "60"
  statistic           = "Maximum"
  threshold           = "1"
  treat_missing_data  = "notBreaching"
  alarm_actions       = [aws_sns_topic.cis_sns_topic.arn]

  tags = var.tags

  lifecycle {
    ignore_changes = [
      actions_enabled
    ]
  }
}
