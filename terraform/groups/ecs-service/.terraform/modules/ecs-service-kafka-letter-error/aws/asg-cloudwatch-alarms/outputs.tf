output "healthy_instances" {
  value       = aws_cloudwatch_metric_alarm.healthy_instances
  description = "The CloudWatch Metric Alarm resource instances in service"
}

output "pending_instances" {
  value       = aws_cloudwatch_metric_alarm.pending_instances
  description = "The CloudWatch Metric Alarm resource instances in pending"
}

output "standby_instances" {
  value       = aws_cloudwatch_metric_alarm.standby_instances
  description = "The CloudWatch Metric Alarm resource instances in standby"
}

output "terminating_instances" {
  value       = aws_cloudwatch_metric_alarm.terminating_instances
  description = "The CloudWatch Metric Alarm resource instances in terminating"
}

output "total_instances_lower" {
  value       = aws_cloudwatch_metric_alarm.total_instances_lower
  description = "The CloudWatch Metric Alarm resource for total instances"
}

output "total_instances_greater" {
  value       = aws_cloudwatch_metric_alarm.total_instances_greater
  description = "The CloudWatch Metric Alarm resource for total instances"
}
