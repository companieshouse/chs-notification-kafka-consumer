data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "access_logs" {
  statement {
    sid    = "AllowPutObjectForS3LoggingService"
    effect = "Allow"

    resources = [
      "${aws_s3_bucket.access_logs.arn}/*"
    ]

    actions = ["s3:PutObject"]

    principals {
      type        = "Service"
      identifiers = ["logging.s3.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      values   = [data.aws_caller_identity.current.account_id]
      variable = "aws:SourceAccount"
    }
  }

  statement {
    sid    = "DenyPutOrDeleteObjectForAllPrincipalsOtherThanS3LoggingService"
    effect = "Deny"

    resources = [
      "${aws_s3_bucket.access_logs.arn}/*"
    ]

    actions = [
      "s3:PutObject",
      "s3:DeleteObject"
    ]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    condition {
      test     = "ForAllValues:StringNotEquals"
      values   = ["logging.s3.amazonaws.com"]
      variable = "aws:PrincipalServiceNamesList"
    }
  }

  statement {
    sid    = "DenyAllWhereSecureTransportNotUsed"
    effect = "Deny"

    resources = [
      aws_s3_bucket.access_logs.arn,
      "${aws_s3_bucket.access_logs.arn}/*"
    ]

    actions = ["s3:*"]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    condition {
      test     = "Bool"
      values   = ["false"]
      variable = "aws:SecureTransport"
    }
  }
}
