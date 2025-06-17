output "occm_id" {
  value       = element(concat(netapp-cloudmanager_connector_aws.this[*].id, [""]), 0)
  description = "ID of the Cloudmanager Connector"
}

output "occm_client_id" {
  value       = element(concat(netapp-cloudmanager_connector_aws.this[*].client_id, [""]), 0)
  description = "Client ID of the Cloudmanager Connector"
}

output "occm_account_id" {
  value       = element(concat(netapp-cloudmanager_connector_aws.this[*].account_id, [""]), 0)
  description = "Account ID of the Cloudmanager Connector"
}

output "occm_role_unique_id" {
  value       = aws_iam_role.this.unique_id
  description = "Unique identifier of the role created for Cloudmanager Connector"
}

output "occm_instance_profile_arn" {
  value       = aws_iam_instance_profile.this.arn
  description = "ARN of the instance profile created for Cloudmanager Connector"
}

output "occm_instance_profile_name" {
  value       = aws_iam_instance_profile.this.name
  description = "Name of the instance profile created for Cloudmanager Connector"
}

output "occm_instance_profile_unique_id" {
  value       = aws_iam_instance_profile.this.unique_id
  description = "Unique identifier of the instance profile created for Cloudmanager Connector"
}

output "occm_security_group_id" {
  value       = aws_security_group.this.id
  description = "ID of the security group Cloudmanager Connector is a member of"
}
