# Output variable definitions
output "ec2_cpuutilization" {
  value       = aws_cloudwatch_metric_alarm.ec2_cpuutilization
  description = "Settings for the ec2_cpuutilization alarm"
}

output "ec2_overallstatus_check" {
  value       = aws_cloudwatch_metric_alarm.ec2_overallstatus_check
  description = "Settings for the ec2_overallstatus_check alarm"
}

output "ec2_systemstatus_check" {
  value       = aws_cloudwatch_metric_alarm.ec2_systemstatus_check
  description = "Settings for the ec2_systemstatus_check alarm"
}

output "ec2_instancestatus_check" {
  value       = aws_cloudwatch_metric_alarm.ec2_instancestatus_check
  description = "Settings for the ec2_instancestatus_check alarm"
}

output "ec2_composite_status" {
  value       = aws_cloudwatch_composite_alarm.ec2_composite_status
  description = "Settings for the ec2_composite_status alarm"
}

output "ec2_instance_availablememory_low" {
  value       = var.enable_memory_alarms ? aws_cloudwatch_metric_alarm.ec2_instance_availablememory_low : null
  description = "Settings for the ec2_instance_availablememory_low alarm"
}

output "ec2_instance_usedmemory_high" {
  value       = var.enable_memory_alarms ? aws_cloudwatch_metric_alarm.ec2_instance_usedmemory_high : null
  description = "Settings for the ec2_instance_usedmemory_high alarm"
}

output "ec2_instance_swapmemory_low" {
  value       = var.enable_memory_alarms ? aws_cloudwatch_metric_alarm.ec2_instance_swapmemory_low : null
  description = "Settings for the ec2_instance_swapmemory_low alarm"
}

output "ec2_instancedisks_low_space" {
  value       = { for alarm in aws_cloudwatch_metric_alarm.ec2_instancedisks_low_space : alarm.id => alarm }
  description = "Settings for the ec2_instancedisks_low_space alarm"
}