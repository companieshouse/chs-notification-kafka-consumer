resource "aws_sns_topic" "cis_sns_topic" {
  name              = "${var.aws_profile}-cis-topic"
  display_name      = "${var.aws_profile}-cis-alarms-topic"
  kms_master_key_id = module.cis_sns_kms.key_arn

  tags = var.tags
}

resource "aws_sns_topic_subscription" "cis_topic_slack_subscription" {
  topic_arn            = aws_sns_topic.cis_sns_topic.arn
  protocol             = "https"
  endpoint             = local.cis_topic_slack_endpoint
  raw_message_delivery = true
}

module "cis_sns_kms" {
  source = "git@github.com:companieshouse/terraform-modules//aws/kms?ref=tags/1.0.267"

  kms_key_alias                      = "${var.account}/${var.region}/cis-topic/sns"
  description                        = "SNS ${var.aws_profile}-cis-topic encryption"
  deletion_window_in_days            = 30
  enable_key_rotation                = true
  is_enabled                         = true
  service_principal_names_non_region = ["cloudwatch"]

  tags = var.tags
}
