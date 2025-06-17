output "asg_ids" {
  description = "The ids of the newly created app security groups"
  value       = [for asg in azurerm_application_security_group.this : asg.id]
}

output "asg_names_and_ids" {
  description = "The names and ids of the newly created app security groups"
  value       = zipmap(var.asg_list, [for asg in azurerm_application_security_group.this : asg.id])
}




