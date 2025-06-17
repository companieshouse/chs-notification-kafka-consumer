resource "aws_s3_bucket_policy" "this" {
  count = var.attach_policy ? 1 : 0

  bucket = var.bucket_name
  policy = data.aws_iam_policy_document.this.json

  #Only one of aws_s3_bucket_policy and aws_s3_bucket_ownership_controls can be deployed at a time, depends_on used to force application order
  depends_on = [aws_s3_bucket_ownership_controls.this]
}

data "aws_iam_policy_document" "this" {

  dynamic "statement" {
    for_each = length(concat(var.bucket_read_accounts, var.bucket_write_accounts)) == 0 ? [] : [concat(var.bucket_read_accounts, var.bucket_write_accounts)]
    content {
      sid    = "AllowCrossAccountRead"
      effect = "Allow"
      principals {
        type        = "AWS"
        identifiers = formatlist("arn:aws:iam::%s:root", statement.value)
      }
      resources = [
        "arn:aws:s3:::${var.bucket_name}",
        "arn:aws:s3:::${var.bucket_name}/*",
      ]
      actions = [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:GetObjectVersionTagging",
        "s3:ListBucket",
        "s3:ListBucketVersions",
        "s3:GetBucketAcl",
        "s3:GetBucketLocation",
        "s3:GetEncryptionConfiguration",
      ]
    }
  }

  dynamic "statement" {
    for_each = length(var.bucket_write_accounts) == 0 ? [] : [var.bucket_write_accounts]
    content {
      sid    = "AllowCrossAccountWrite"
      effect = "Allow"
      principals {
        type        = "AWS"
        identifiers = formatlist("arn:aws:iam::%s:root", statement.value)
      }
      resources = [
        "arn:aws:s3:::${var.bucket_name}/*",
      ]
      actions = [
        "s3:PutObject",
        "s3:PutObjectACL",
      ]
      condition {
        test     = "StringEquals"
        variable = "s3:x-amz-acl"
        values   = ["bucket-owner-full-control"]
      }
    }
  }

  dynamic "statement" {
    for_each = length(var.bucket_write_accounts_no_acl) == 0 ? [] : [var.bucket_write_accounts_no_acl]
    content {
      sid    = "AllowCrossAccountWrite"
      effect = "Allow"
      principals {
        type        = "AWS"
        identifiers = formatlist("arn:aws:iam::%s:root", statement.value)
      }
      resources = [
        "arn:aws:s3:::${var.bucket_name}/*",
      ]
      actions = [
        "s3:PutObject",
        "s3:PutObjectACL",
      ]
    }
  }

  dynamic "statement" {
    for_each = length(var.bucket_delete_accounts) == 0 ? [] : [var.bucket_delete_accounts]
    content {
      sid    = "AllowCrossAccountDelete"
      effect = "Allow"
      principals {
        type        = "AWS"
        identifiers = formatlist("arn:aws:iam::%s:root", statement.value)
      }
      resources = [
        "arn:aws:s3:::${var.bucket_name}/*",
      ]
      actions = [
        "s3:DeleteObject",
      ]
    }
  }

  dynamic "statement" {
    for_each = var.s3_bucket_allow_ssl_only ? [1] : []
    content {
      sid    = "AllowSSLRequestsOnly"
      effect = "Deny"
      principals {
        type        = "*"
        identifiers = ["*"]
      }
      resources = [
        "arn:aws:s3:::${var.bucket_name}",
        "arn:aws:s3:::${var.bucket_name}/*",
      ]
      actions = [
        "s3:*",
      ]
      condition {
        test     = "Bool"
        variable = "aws:SecureTransport"
        values   = ["false"]
      }
    }
  }

  dynamic "statement" {
    for_each = var.custom_statements != null ? var.custom_statements : []
    content {
      sid       = statement.value["sid"]
      effect    = statement.value["effect"]
      resources = statement.value["resources"]
      actions   = statement.value["actions"]

      dynamic "principals" {
        for_each = lookup(statement.value, "principals", [])
        content {
          identifiers = principals.value.identifiers
          type        = principals.value.type
        }
      }
    }
  }
}

resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = var.bucket_name

  rule {
    object_ownership = var.s3_bucket_ownership_control
  }
}
