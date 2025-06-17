output "alarm_unhealthy_host_count" {
  value       = aws_cloudwatch_metric_alarm.unhealthy_hosts
  description = "The CloudWatch Metric Alarm resource block for unhealthy host count"
}

output "alarm_httpcode_target_4xx_count" {
  value       = aws_cloudwatch_metric_alarm.httpcode_target_4xx_count
  description = "The CloudWatch Metric Alarm resource block for target httpcode target 4xx count"
}

output "alarm_httpcode_lb_4xx_count" {
  value       = aws_cloudwatch_metric_alarm.httpcode_lb_4xx_count
  description = "The CloudWatch Metric Alarm resource block for load balancer httpcode target 4xx count"
}

output "alarm_httpcode_target_5xx_count" {
  value       = aws_cloudwatch_metric_alarm.httpcode_target_5xx_count
  description = "The CloudWatch Metric Alarm resource block for target httpcode target 5xx count"
}

output "alarm_httpcode_lb_5xx_count" {
  value       = aws_cloudwatch_metric_alarm.httpcode_lb_5xx_count
  description = "The CloudWatch Metric Alarm resource block for load balancer httpcode target 5xx count"
}

output "target_response_time_average" {
  value       = aws_cloudwatch_metric_alarm.target_response_time_average
  description = "The CloudWatch Metric Alarm resource block for target response time"
}

output "alarm_client_tls_neg_err_count" {
  value       = aws_cloudwatch_metric_alarm.client_tls_neg_err_count
  description = "The CloudWatch Metric Alarm resource block for client tls negotiation error count"
}
