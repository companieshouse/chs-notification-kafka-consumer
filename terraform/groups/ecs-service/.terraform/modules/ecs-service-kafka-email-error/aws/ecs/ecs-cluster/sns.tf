module "cloudwatch_sns_alerting_notify_topic" {
  count = var.create_sns_notify_topic ? 1 : 0

  source  = "terraform-aws-modules/sns/aws"
  version = "5.0.0"

  name = "${var.name_prefix}-cloudwatch-alarms-notify-topic"

  tags = {
    Name        = "${var.name_prefix}-cloudwatch-alarms-notify-topic"
    Environment = var.environment
  }
}

module "cloudwatch_sns_alerting_ooh_topic" {
  count = var.create_sns_ooh_topic ? 1 : 0

  source  = "terraform-aws-modules/sns/aws"
  version = "5.0.0"

  name = "${var.name_prefix}-cloudwatch-alarms-ooh-topic"

  tags = {
    Name        = "${var.name_prefix}-cloudwatch-alarms-ooh-topic"
    Environment = var.environment
  }
}

resource "aws_sns_topic_subscription" "notify_topic_slack_subscription" {
  count = var.create_sns_notify_topic && length(var.notify_topic_slack_endpoint) > 0 ? 1 : 0

  topic_arn            = module.cloudwatch_sns_alerting_notify_topic[0].topic_arn
  protocol             = "https"
  endpoint             = var.notify_topic_slack_endpoint
  raw_message_delivery = true
}