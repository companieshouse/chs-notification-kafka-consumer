data "aws_cloudwatch_log_group" "alerts" {
  name = local.alert_log_group_name
}

data "aws_sns_topic" "alarms" {
  count = var.alarm_actions_enabled && var.alarm_topic_name != "" ? 1 : 0

  name = var.alarm_topic_name
}

data "aws_sns_topic" "alarms_ooh" {
  count = var.alarm_actions_enabled && var.alarm_topic_name_ooh != "" ? 1 : 0

  name = var.alarm_topic_name_ooh
}
