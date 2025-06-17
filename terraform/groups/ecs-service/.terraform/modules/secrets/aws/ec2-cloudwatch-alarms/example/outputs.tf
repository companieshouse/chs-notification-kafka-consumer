# Output variable definitions
output "ec2_cpuutilization" {
  value       = module.cloudwatch_alarms.ec2_cpuutilization
  description = "Settings for the ec2_cpuutilization alarm"
}

output "ec2_overallstatus_check" {
  value       = module.cloudwatch_alarms.ec2_overallstatus_check
  description = "Settings for the ec2_overallstatus_check alarm"
}

output "ec2_systemstatus_check" {
  value       = module.cloudwatch_alarms.ec2_systemstatus_check
  description = "Settings for the ec2_systemstatus_check alarm"
}

output "ec2_instancestatus_check" {
  value       = module.cloudwatch_alarms.ec2_instancestatus_check
  description = "Settings for the ec2_instancestatus_check alarm"
}

output "ec2_instance_availablememory_low" {
  value       = module.cloudwatch_alarms.ec2_instance_availablememory_low
  description = "Settings for the ec2_instance_availablememory_low alarm"
}

output "ec2_instance_usedmemory_high" {
  value       = module.cloudwatch_alarms.ec2_instance_usedmemory_high
  description = "Settings for the ec2_instance_usedmemory_high alarm"
}

output "ec2_instance_swapmemory_low" {
  value       = module.cloudwatch_alarms.ec2_instance_swapmemory_low
  description = "Settings for the ec2_instance_swapmemory_low alarm"
}

output "ec2_instancedisks_low_space" {
  value       = module.cloudwatch_alarms.ec2_instancedisks_low_space
  description = "Settings for the ec2_instancedisks_low_space alarm"
}