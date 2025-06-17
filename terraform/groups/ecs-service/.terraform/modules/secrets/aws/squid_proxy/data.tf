data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_subnet" "private_subnets" {
  count = length(var.private_subnet_ids)

  id = var.private_subnet_ids[count.index]
}

data "aws_kms_key" "ssm_logs_kms_key" {
  count  = var.ssm_logs_kms_key != null ? (var.enable_ssm ? 1 : 0) : 0
  key_id = var.ssm_logs_kms_key
}

data "aws_kms_key" "ssm_session_kms_key" {
  count  = var.ssm_session_kms_key != null ? (var.enable_ssm ? 1 : 0) : 0
  key_id = var.ssm_session_kms_key
}

data "aws_iam_policy" "ssm" {
  count = var.enable_ssm ? 1 : 0
  arn   = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
