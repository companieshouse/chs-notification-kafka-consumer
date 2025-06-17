output "this_iam_role_arn" {
  description = "ARN for the IAM role"
  value       = { for k, v in aws_iam_role.this : k => v.arn if var.rds_schedule_enable == true }
}

output "this_iam_role_name" {
  description = "Name of the IAM role"
  value       = { for k, v in aws_iam_role.this : k => v.name if var.rds_schedule_enable == true }
}

output "this_ssm_start_schedule_id" {
  description = "Id of the start schedule's SSM Association"
  value       = { for k, v in aws_ssm_association.this_start : k => v.association_id if var.rds_schedule_enable == true }
}

output "this_ssm_stop_schedule_id" {
  description = "Id of the stop schedule's SSM Association"
  value       = { for k, v in aws_ssm_association.this_stop : k => v.association_id if var.rds_schedule_enable == true }
}
