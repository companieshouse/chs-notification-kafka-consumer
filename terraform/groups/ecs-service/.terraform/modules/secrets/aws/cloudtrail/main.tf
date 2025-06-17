# The AWS region currently being used.
data "aws_region" "current" {
}

# The AWS account id
data "aws_caller_identity" "current" {
}

# The AWS partition (commercial or govcloud)
data "aws_partition" "current" {}

#
# CloudTrail - CloudWatch
#
# This section is used for allowing CloudTrail to send logs to CloudWatch.
#

# This policy allows the CloudTrail service for any account to assume this role.
data "aws_iam_policy_document" "cloudtrail_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }
}

# This role is used by CloudTrail to send logs to CloudWatch.
resource "aws_iam_role" "cloudtrail_cloudwatch_role" {
  count = var.cloudwatch_logging ? 1 : 0

  name               = "cloudtrail-cloudwatch-logs-role"
  assume_role_policy = data.aws_iam_policy_document.cloudtrail_assume_role.json
}

# This CloudWatch Group is used for storing CloudTrail logs.
resource "aws_cloudwatch_log_group" "cloudtrail" {
  count = var.cloudwatch_logging ? 1 : 0

  name              = var.cloudwatch_log_group_name
  retention_in_days = var.log_retention_days
  kms_key_id        = var.encrypt_trail ? data.aws_kms_key.cloudtrail[0].arn : null

  tags = merge(
    {
      "Name" = var.cloudwatch_log_group_name
    },
    var.tags,
  )
}

data "aws_iam_policy_document" "cloudtrail_cloudwatch_logs" {
  statement {
    sid = "WriteCloudWatchLogs"

    effect = "Allow"

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["arn:${data.aws_partition.current.partition}:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:${var.cloudwatch_log_group_name}:*"]
  }
}

resource "aws_iam_policy" "cloudtrail_cloudwatch_logs" {
  count = var.cloudwatch_logging ? 1 : 0

  name   = "cloudtrail-cloudwatch-logs-policy"
  policy = data.aws_iam_policy_document.cloudtrail_cloudwatch_logs.json
}

resource "aws_iam_policy_attachment" "main" {
  count = var.cloudwatch_logging ? 1 : 0

  name       = "cloudtrail-cloudwatch-logs-policy-attachment"
  policy_arn = aws_iam_policy.cloudtrail_cloudwatch_logs[0].arn
  roles      = [aws_iam_role.cloudtrail_cloudwatch_role[0].name]
}

#
# KMS
#
data "aws_kms_key" "cloudtrail" {
  count = var.encrypt_trail ? 1 : 0

  key_id = var.kms_key
}

#
# CloudTrail
#
resource "aws_cloudtrail" "main" {
  name = var.trail_name

  # Send logs to CloudWatch Logs
  cloud_watch_logs_group_arn = var.cloudwatch_logging ? "${aws_cloudwatch_log_group.cloudtrail[0].arn}:*" : null
  cloud_watch_logs_role_arn  = var.cloudwatch_logging ? aws_iam_role.cloudtrail_cloudwatch_role[0].arn : null

  # Send logs to S3
  s3_key_prefix  = var.s3_key_prefix
  s3_bucket_name = var.s3_bucket_name

  # Note that organization trails can *only* be created in organization
  # master accounts; this will fail if run in a non-master account.
  is_organization_trail = var.org_trail

  # use a single s3 bucket for all aws regions
  is_multi_region_trail = true

  # enable log file validation to detect tampering
  enable_log_file_validation = true

  kms_key_id = var.encrypt_trail ? data.aws_kms_key.cloudtrail[0].arn : null

  # Enables logging for the trail. Defaults to true. Setting this to false will pause logging.
  enable_logging = var.enabled

  dynamic "event_selector" {
    for_each = var.event_selector
    content {
      include_management_events = lookup(event_selector.value, "include_management_events", null)
      read_write_type           = lookup(event_selector.value, "read_write_type", null)

      dynamic "data_resource" {
        for_each = lookup(event_selector.value, "data_resource", [])
        content {
          type   = data_resource.value.type
          values = data_resource.value.values
        }
      }
    }
  }

  tags = merge(
    {
      "Name" = var.trail_name
    },
    var.tags,
  )
}
