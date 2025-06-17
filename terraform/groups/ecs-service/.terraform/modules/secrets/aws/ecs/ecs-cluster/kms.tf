data "aws_iam_policy_document" "ec2_ebs" {
  statement {
    sid = "DefaultIAMUserPermissions"

    actions = [
      "kms:*"
    ]

    resources = ["*"]

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      ]
    }
  }

  statement {
    sid = "AllowKMSActionsForAutoscaling"

    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncryptFrom",
      "kms:ReEncryptTo",
      "kms:GenerateDataKey",
      "kms:GenerateDataKeyWithoutPlaintext",
      "kms:DescribeKey"
    ]

    resources = ["*"]

    principals {
      type = "AWS"
      identifiers = [
        data.aws_iam_role.asg.arn
      ]
    }
  }

  statement {
    sid = "AllowKMSGrantForAutoscaling"

    actions = [
      "kms:CreateGrant"
    ]

    resources = ["*"]

    principals {
      type = "AWS"
      identifiers = [
        data.aws_iam_role.asg.arn
      ]
    }

    condition {
      test     = "Bool"
      variable = "kms:GrantIsForAWSResource"
      values   = ["true"]
    }
  }
}

resource "aws_kms_key" "ec2_ebs" {
  description         = "KMS key for ECS cluster EBS volume encryption"
  enable_key_rotation = false
  policy              = data.aws_iam_policy_document.ec2_ebs.json
}

resource "aws_kms_alias" "ec2_ebs" {
  name          = "alias/${var.name_prefix}-ec2-ebs-kms"
  target_key_id = aws_kms_key.ec2_ebs.key_id
}
