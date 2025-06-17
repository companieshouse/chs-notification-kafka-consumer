output "healthy_instances" {
  value = module.asg_alarms.healthy_instances
}

output "pending_instances" {
  value = module.asg_alarms.pending_instances
}

output "standby_instances" {
  value = module.asg_alarms.standby_instances
}

output "terminating_instances" {
  value = module.asg_alarms.terminating_instances
}

output "total_instances_lower" {
  value = module.asg_alarms.total_instances_lower
}

output "total_instances_greater" {
  value = module.asg_alarms.total_instances_greater
}
