output "aws_iam_policy" {
  value = module.instance_policy.aws_iam_policy
}

output "aws_iam_role" {
  value = module.instance_policy.aws_iam_role
}

output "aws_iam_role_policy_attachment" {
  value = module.instance_policy.aws_iam_role_policy_attachment
}

output "aws_iam_instance_profile" {
  value = module.instance_policy.aws_iam_instance_profile
}