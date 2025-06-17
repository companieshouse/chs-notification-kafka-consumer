output "cvo_id" {
  value       = netapp-cloudmanager_cvo_aws.cvo_aws.id
  description = "ID of the Cloudmanager CVO environment"
}

output "cvo_role_arn" {
  value       = aws_iam_role.this.arn
  description = "ARN of the role created for CVO instances"
}

output "cvo_role_name" {
  value       = aws_iam_role.this.name
  description = "Name of the role created for CVO instances"
}

output "cvo_role_unique_id" {
  value       = aws_iam_role.this.unique_id
  description = "Unique identifier of the role created for CVO instances"
}

output "cvo_instance_profile_arn" {
  value       = aws_iam_instance_profile.this.arn
  description = "ARN of the instance profile created for CVO instances"
}

output "cvo_instance_profile_name" {
  value       = aws_iam_instance_profile.this.name
  description = "Name of the instance profile created for CVO instances"
}

output "cvo_instance_profile_unique_id" {
  value       = aws_iam_instance_profile.this.unique_id
  description = "Unique identifier of the instance profile created for CVO instances"
}

output "cvo_security_group_id" {
  value       = aws_security_group.this.id
  description = "ID of the security group all CVO instances are a memeber of"
}
