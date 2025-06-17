output "this_aws_config_configuration_recorder_id" {
  value       = join("", aws_config_configuration_recorder.this.*.id)
  description = "Name of the recorder"
}

output "this_aws_config_delivery_channel_id" {
  value       = join("", aws_config_delivery_channel.this.*.id)
  description = "The name of the delivery channel"
}

output "this_aws_config_delivery_channel_s3_bucket_name" {
  value       = join("", aws_config_delivery_channel.this.*.s3_bucket_name)
  description = "The name of the s3 bucket the delivery channel records to"
}

output "this_aws_config_delivery_channel_s3_key_prefix" {
  value       = join("", aws_config_delivery_channel.this.*.s3_key_prefix)
  description = "Optional prefix on delivery channel S3 output"
}

output "this_aws_config_rules" {
  value       = aws_config_config_rule.rules
  description = "If created, list of maps of all attributes of created config rules"
}

output "this_aws_iam_role_id" {
  value       = join("", aws_iam_role.this.*.id)
  description = "Name of the IAM role used by AWS Config"
}

output "this_aws_iam_role_arn" {
  value       = join("", aws_iam_role.this.*.arn)
  description = "ARN of the IAM role used by AWS Config"
}

output "this_aws_iam_role_unique_id" {
  value       = join("", aws_iam_role.this.*.unique_id)
  description = "Unique ID of the IAM role used by AWS Config"
}

output "this_aws_config_configuration_aggregator_arn" {
  value       = element(concat(aws_config_configuration_aggregator.this[*].arn, [""]), 0)
  description = "The ARN of the config aggregator (if created)"
}

output "this_aws_config_aggregate_authorization_arn" {
  value       = element(concat(aws_config_aggregate_authorization.this[*].arn, [""]), 0)
  description = "The ARN of the config aggregator authorization (if created)"
}
