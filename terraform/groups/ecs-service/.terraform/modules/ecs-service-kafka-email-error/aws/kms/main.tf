data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

resource "aws_kms_key" "this" {
  description             = var.description
  key_usage               = "ENCRYPT_DECRYPT"
  policy                  = data.aws_iam_policy_document.key_policy.json
  deletion_window_in_days = var.deletion_window_in_days
  is_enabled              = var.is_enabled
  enable_key_rotation     = var.enable_key_rotation #tfsec:ignore:AWS019
  tags                    = var.tags
}

resource "aws_kms_alias" "this" {
  count = var.kms_key_alias != null ? 1 : 0

  name          = "alias/${var.kms_key_alias}"
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

  dynamic "statement" {
    for_each = var.kmsadmin_principals != null ? [""] : []
    content {
      sid    = "AllowAccessKeyAdministrators"
      effect = "Allow"
      actions = [
        "kms:Create*",
        "kms:Describe*",
        "kms:Enable*",
        "kms:List*",
        "kms:Put*",
        "kms:Update*",
        "kms:Revoke*",
        "kms:Disable*",
        "kms:Get*",
        "kms:Delete*",
        "kms:TagResource",
        "kms:UntagResource",
        "kms:ScheduleKeyDeletion",
        "kms:CancelKeyDeletion"
      ]
      resources = ["*"]

      principals {
        type        = "AWS"
        identifiers = formatlist("arn:aws:iam::%s:%s", data.aws_caller_identity.current.account_id, var.kmsadmin_principals)
      }
    }
  }

  dynamic "statement" {
    for_each = var.kmsuser_principals != null ? [""] : []
    content {
      sid    = "AllowKeyUsers"
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
        type        = "AWS"
        identifiers = formatlist("arn:aws:iam::%s:%s", data.aws_caller_identity.current.account_id, var.kmsuser_principals)
      }
    }
  }

  dynamic "statement" {
    for_each = var.key_usage_foreign_account_ids != null ? [""] : []
    content {
      sid    = "AllowRemoteAccountUsage"
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
        type        = "AWS"
        identifiers = formatlist("arn:aws:iam::%s:root", var.key_usage_foreign_account_ids)
      }
    }
  }

  dynamic "statement" {
    for_each = var.key_grant_foreign_account_ids != null ? [""] : []
    content {
      sid    = "AllowRemoteAccountGrant"
      effect = "Allow"
      actions = [
        "kms:CreateGrant"
      ]
      resources = ["*"]
      principals {
        type        = "AWS"
        identifiers = formatlist("arn:aws:iam::%s:root", var.key_grant_foreign_account_ids)
      }
    }
  }


  dynamic "statement" {
    for_each = var.service_linked_role_principals != null ? [""] : []
    content {
      sid    = "AllowServiceLinkedRoleUsage"
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
        type        = "AWS"
        identifiers = formatlist("arn:aws:iam::%s:role/aws-service-role/%s", data.aws_caller_identity.current.account_id, var.service_linked_role_principals)
      }
    }
  }

  dynamic "statement" {
    for_each = var.service_linked_role_principals != null ? [""] : []
    content {
      sid    = "AllowServiceLinkedRoleGrant"
      effect = "Allow"
      actions = [
        "kms:CreateGrant"
      ]
      resources = ["*"]
      principals {
        type        = "AWS"
        identifiers = formatlist("arn:aws:iam::%s:role/aws-service-role/%s", data.aws_caller_identity.current.account_id, var.service_linked_role_principals)
      }
      condition {
        test     = "Bool"
        variable = "kms:GrantIsForAWSResource"
        values = [
          "true"
        ]
      }
    }
  }

  dynamic "statement" {
    for_each = var.service_principal_names != null ? ["1"] : []
    content {
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
        identifiers = formatlist("%s.%s.amazonaws.com", var.service_principal_names, data.aws_region.current.name)
      }
    }
  }

  dynamic "statement" {
    for_each = var.service_principal_names_non_region != null ? ["1"] : []
    content {
      sid    = "AllowServicePrinciplesNonRegion"
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
        identifiers = formatlist("%s.amazonaws.com", var.service_principal_names_non_region)
      }
    }
  }

  dynamic "statement" {
    for_each = var.cloudtrail_account_ids != null ? ["1"] : []
    content {
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
        values   = formatlist("arn:aws:cloudtrail:*:%s:trail/*", var.cloudtrail_account_ids)
      }
    }
  }

  dynamic "statement" {
    for_each = var.cloudtrail_account_ids != null ? ["1"] : []
    content {
      sid       = "CloudTrailDescribe"
      effect    = "Allow"
      actions   = ["kms:DescribeKey"]
      resources = ["*"]
      principals {
        type        = "Service"
        identifiers = ["cloudtrail.amazonaws.com"]
      }
    }
  }
}
