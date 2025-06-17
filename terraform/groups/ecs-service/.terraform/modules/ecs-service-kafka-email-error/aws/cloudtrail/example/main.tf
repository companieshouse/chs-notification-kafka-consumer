module "aws_cloudtrail" {
  source = "../../cloudtrail"

  trail_name         = var.trail_name
  cloudwatch_logging = true
  kms_key            = "alias/${var.kms_name}"
  encrypt_trail      = true

  s3_bucket_name = module.logs.aws_logs_bucket
  s3_key_prefix  = var.s3_key_prefix

  tags = merge(
    map(
      "Terratest", "True"
    )
  )
  depends_on = [aws_kms_alias.this]
}

module "logs" {
  source  = "trussworks/logs/aws"
  version = "~> 9.0.0"

  s3_bucket_name = var.logs_bucket
  region         = var.region

  cloudtrail_logs_prefix = var.s3_key_prefix
  allow_cloudtrail       = true

  force_destroy = true
}

resource "aws_kms_key" "this" {
  description             = "${var.kms_name} testing key"
  key_usage               = "ENCRYPT_DECRYPT"
  policy                  = data.aws_iam_policy_document.key_policy.json
  deletion_window_in_days = 7
  is_enabled              = true
  enable_key_rotation     = false #tfsec:ignore:AWS019
}

resource "aws_kms_alias" "this" {
  name          = "alias/${var.kms_name}"
  target_key_id = aws_kms_key.this.id
}

data "aws_iam_policy_document" "key_policy" {
  statement {
    sid    = "AllowIAMPermissions"
    effect = "Allow"
    actions = [
      "kms:*"
    ]
    resources = ["*"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }

  statement {
    sid       = "CloudTrailEncrypt"
    effect    = "Allow"
    actions   = ["kms:GenerateDataKey*"]
    resources = ["*"]
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    condition {
      test     = "StringLike"
      variable = "kms:EncryptionContext:aws:cloudtrail:arn"
      values   = [format("arn:aws:cloudtrail:*:%s:trail/*", data.aws_caller_identity.current.account_id)]
    }
  }

  statement {
    sid       = "CloudTrailDescribe"
    effect    = "Allow"
    actions   = ["kms:DescribeKey"]
    resources = ["*"]
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }
  statement {
    sid    = "AllowServicePrinciples"
    effect = "Allow"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources = ["*"]
    principals {
      type        = "Service"
      identifiers = formatlist("%s.%s.amazonaws.com", "logs", data.aws_region.current.name)
    }
  }
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}