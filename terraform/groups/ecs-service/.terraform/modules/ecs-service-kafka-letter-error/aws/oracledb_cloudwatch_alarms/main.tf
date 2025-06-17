resource "aws_cloudwatch_log_metric_filter" "filters" {
  for_each = local.metric_data

  name           = lookup(each.value, "name")
  pattern        = lookup(each.value, "filter_pattern")
  log_group_name = data.aws_cloudwatch_log_group.alerts.name

  metric_transformation {
    name          = "${each.key}_metric"
    namespace     = local.metric_namespace
    value         = lookup(each.value, "filter_metric_value")
    default_value = lookup(each.value, "filter_metric_default_value")
  }
}

resource "aws_cloudwatch_metric_alarm" "alarms" {
  for_each = local.metric_data

  alarm_name          = "${var.alarm_name_prefix}: ${lookup(each.value, "name")}"
  alarm_description   = lookup(each.value, "description")
  metric_name         = aws_cloudwatch_log_metric_filter.filters[each.key].metric_transformation[0].name
  namespace           = local.metric_namespace

  comparison_operator = lookup(each.value, "comparison_operator")
  datapoints_to_alarm = lookup(each.value, "datapoints_to_alarm")
  evaluation_periods  = lookup(each.value, "evaluation_periods")
  period              = lookup(each.value, "period")
  statistic           = lookup(each.value, "statistic")
  threshold           = lookup(each.value, "threshold")
  treat_missing_data  = "notBreaching"

  actions_enabled     = var.alarm_actions_enabled
  alarm_actions       = lookup(each.value, "sns_topic_arn_list")
  ok_actions          = local.alarm_sns_topic_arn_email
}
