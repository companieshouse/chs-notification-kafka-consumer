output "security_group" {
  value = aws_security_group.this
}

output "autoscaling_group_names" {
  value = aws_autoscaling_group.this[*].name
}

output "autoscaling_group_arns" {
  value = aws_autoscaling_group.this[*].arn
}

output "sns_topic_arn" {
  value = aws_sns_topic.this.arn
}

output "lambda_arn" {
  value = aws_lambda_function.this.arn
}
