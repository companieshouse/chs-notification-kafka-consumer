output "occm_id" {
  value       = module.netapp_connector.occm_id
  description = "ID of the Cloudmanager Connector"
}

output "occm_client_id" {
  value       = module.netapp_connector.occm_client_id
  description = "Client ID of the Cloudmanager Connector"
}

output "occm_account_id" {
  value       = module.netapp_connector.occm_account_id
  description = "Account ID of the Cloudmanager Connector"
}

output "occm_role_unique_id" {
  value       = module.netapp_connector.occm_role_unique_id
  description = "Unique identifier of the role created for Cloudmanager Connector"
}

output "occm_instance_profile_arn" {
  value       = module.netapp_connector.occm_instance_profile_arn
  description = "ARN of the instance profile created for Cloudmanager Connector"
}

output "occm_instance_profile_name" {
  value       = module.netapp_connector.occm_instance_profile_name
  description = "Name of the instance profile created for Cloudmanager Connector"
}

output "occm_instance_profile_unique_id" {
  value       = module.netapp_connector.occm_instance_profile_unique_id
  description = "Unique identifier of the instance profile created for Cloudmanager Connector"
}

output "occm_security_group_id" {
  value       = module.netapp_connector.occm_security_group_id
  description = "ID of the security group Cloudmanager Connector is a member of"
}