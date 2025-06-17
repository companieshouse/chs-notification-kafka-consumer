data "aws_iam_policy" "ssm" {
  count = var.enable_ssm ? 1 : 0
  arn   = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

data "aws_kms_key" "this" {
  count  = var.kms_key_refs != null ? length(var.kms_key_refs) : 0
  key_id = var.kms_key_refs[count.index]
}

data "aws_kms_key" "ssm_kms_key" {
  count  = var.ssm_kms_key != null ? (var.enable_ssm ? 1 : 0) : 0
  key_id = var.ssm_kms_key
}

data "aws_iam_policy_document" "this" {

  statement {
    sid       = "GetCallerIdentity"
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "sts:GetCallerIdentity",
    ]
  }

  dynamic "statement" {
    for_each = var.cw_log_group_arns != null ? [1] : []
    content {
      sid       = "CloudWatchLogGroupWrite"
      effect    = "Allow"
      resources = var.cw_log_group_arns
      actions = [
        "logs:CreateLogStream",
        "logs:PutLogEvents",
      ]
    }
  }

  dynamic "statement" {
    for_each = var.instance_asg_arns != null ? [1] : []
    content {
      sid       = "AllowInstanceHealthActions"
      effect    = "Allow"
      resources = var.instance_asg_arns
      actions = [
        "autoscaling:SetInstanceHealth"
      ]
    }
  }

  dynamic "statement" {
    for_each = var.kms_key_refs != null ? [1] : []
    content {
      sid    = "KMSOperations"
      effect = "Allow"
      resources = [
        for key in data.aws_kms_key.this : key.arn
      ]
      actions = [
        "kms:Decrypt",
        "kms:DescribeKey",
        "kms:Encrypt",
        "kms:GenerateDataKey*",
        "kms:ReEncrypt*",
      ]
    }
  }

  dynamic "statement" {
    for_each = var.ssm_kms_key != null ? (var.enable_ssm ? [1] : []) : []
    content {
      sid    = "SSMKMSOperations"
      effect = "Allow"
      resources = [
        data.aws_kms_key.ssm_kms_key.0.arn
      ]
      actions = [
        "kms:Decrypt",
      ]
    }
  }

  dynamic "statement" {
    for_each = var.enable_ssm ? [1] : []
    content {
      sid       = "SSMS3Operations"
      effect    = "Allow"
      resources = ["*"]
      actions = [
        "s3:GetEncryptionConfiguration",
      ]
    }
  }

  dynamic "statement" {
    for_each = length(var.s3_buckets_read) > 0 ? [1] : []
    content {
      sid    = "S3readoperations"
      effect = "Allow"
      resources = concat(
        formatlist("arn:aws:s3:::%s", var.s3_buckets_read),
        formatlist("arn:aws:s3:::%s/*", var.s3_buckets_read),
      )
      actions = [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:GetObjectVersionTagging",
        "s3:ListBucket",
        "s3:ListBucketVersions",
        "s3:GetBucketAcl",
        "s3:GetEncryptionConfiguration",
      ]
    }
  }

  dynamic "statement" {
    for_each = length(var.s3_buckets_write) > 0 ? [1] : []
    content {
      sid    = "S3writeoperations"
      effect = "Allow"
      resources = concat(
        formatlist("arn:aws:s3:::%s", var.s3_buckets_write),
        formatlist("arn:aws:s3:::%s/*", var.s3_buckets_write),
      )
      actions = [
        "s3:PutObject",
        "s3:PutObjectACL",
      ]
    }
  }

  dynamic "statement" {
    for_each = length(var.s3_buckets_delete) > 0 ? [1] : []
    content {
      sid    = "S3deleteoperations"
      effect = "Allow"
      resources = concat(
        formatlist("arn:aws:s3:::%s", var.s3_buckets_delete),
        formatlist("arn:aws:s3:::%s/*", var.s3_buckets_delete),
      )
      actions = [
        "s3:DeleteObject",
      ]
    }
  }

  dynamic "statement" {
    for_each = var.custom_statements != null ? var.custom_statements : []
    content {
      sid       = statement.value["sid"]
      effect    = statement.value["effect"]
      resources = statement.value["resources"]
      actions   = statement.value["actions"]
    }
  }

}

resource "aws_iam_policy" "this" {
  name   = "ipol-${var.name}"
  path   = "/"
  policy = data.aws_iam_policy_document.this.json
}

resource "aws_iam_role" "this" {
  name = "irol-${var.name}"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}

resource "aws_iam_role_policy_attachment" "this_ssm" {
  role       = aws_iam_role.this.name
  policy_arn = data.aws_iam_policy.ssm[0].arn
}

resource "aws_iam_instance_profile" "this" {
  name = "iprof-${var.name}"
  role = aws_iam_role.this.name
}
