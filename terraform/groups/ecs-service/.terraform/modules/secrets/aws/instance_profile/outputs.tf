output "aws_iam_policy" {
  value       = aws_iam_policy.this
  description = "Complete output for iam policy, contains all references for this resource"
}

output "aws_iam_role" {
  value       = aws_iam_role.this
  description = "Complete output for iam role, contains all references for this resource"
}

output "aws_iam_role_policy_attachment" {
  value       = aws_iam_role_policy_attachment.this
  description = "Complete output for iam policy attachment, contains all references for this resource"
}

output "aws_iam_instance_profile" {
  value       = aws_iam_instance_profile.this
  description = "Complete output for iam profile, contains all references for this resource"
}