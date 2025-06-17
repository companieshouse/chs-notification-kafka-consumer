

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_kms_key" "this" {
  for_each = var.kms_keys

  key_id = each.value
}

# -----------------------------------------------------------
# Configuration to enable AWS Config Recording
# -----------------------------------------------------------
resource "aws_config_configuration_recorder" "this" {
  count = var.is_recorder ? 1 : 0

  name     = format("%s-%s-%02d", "cfrc", var.name, 1)
  role_arn = coalesce(var.config_recorder_iam_role_arn, aws_iam_role.this.0.arn)

  recording_group {
    all_supported                 = var.config_recorder_all_supported
    include_global_resource_types = var.config_recorder_include_global_resource_types
    resource_types                = var.config_recorder_all_supported ? null : var.config_recorder_resource_types
  }

  depends_on = [
    aws_iam_role_policy_attachment.service_role_policy_attach,
    aws_iam_role_policy_attachment.config_policy_attach,
    aws_iam_role.this,
  ]
}

resource "aws_config_configuration_recorder_status" "this" {
  count = var.is_recorder ? 1 : 0

  name       = aws_config_configuration_recorder.this.0.name
  is_enabled = true

  depends_on = [aws_config_delivery_channel.this]
}

resource "aws_config_delivery_channel" "this" {
  count = var.is_recorder ? 1 : 0

  name = format("%s-%s-%02d", "cfdc", var.name, 1)

  s3_bucket_name = var.config_s3_bucket_name
  s3_key_prefix  = var.config_s3_bucket_prefix
  sns_topic_arn  = var.config_sns_topic_arn

  dynamic "snapshot_delivery_properties" {
    for_each = var.config_delivery_frequency != null ? [1] : []
    content {
      delivery_frequency = var.config_delivery_frequency
    }
  }

  depends_on = [aws_config_configuration_recorder.this]
}

resource "aws_iam_role" "this" {
  count = var.config_recorder_iam_role_arn == null ? 1 : 0

  name = format("%s-%s-%02d", "iamr", var.name, 1)

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "config.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "service_role_policy_attach" {
  count = var.config_recorder_iam_role_arn == null ? 1 : 0

  role       = aws_iam_role.this.0.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/${var.config_recorder_configrole_policy_name}"
}

resource "aws_iam_role_policy_attachment" "config_policy_attach" {
  count = var.config_recorder_iam_role_arn == null ? 1 : 0

  role       = aws_iam_role.this.0.name
  policy_arn = aws_iam_policy.config_policy.0.arn
}

resource "aws_iam_policy" "config_policy" {
  count = var.config_recorder_iam_role_arn == null ? 1 : 0

  name        = format("%s-%s-%02d", "iamp", var.name, 1)
  description = "Policy to grant custom resource access permissions to AWS Config delivery channel"
  policy      = data.aws_iam_policy_document.config_policy.0.json
}

data "aws_iam_policy_document" "config_policy" {
  count = var.config_recorder_iam_role_arn == null ? 1 : 0

  statement {
    sid    = "AllowConfigList"
    effect = "Allow"
    actions = [
      "s3:GetBucketAcl",
      "s3:ListBucket",
    ]
    resources = [
      "arn:aws:s3:::${var.config_s3_bucket_name}",
    ]
  }

  statement {
    sid    = "AllowConfigBucketWrite"
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:PutObjectACL",
    ]
    resources = [
      local.config_s3_bucket_path
    ]
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }

  dynamic "statement" {
    for_each = length(var.kms_keys) > 0 ? [1] : []

    content {
      sid       = "KMSOperations"
      effect    = "Allow"
      resources = data.aws_kms_key.this.*.arn
      actions = [
        "kms:Decrypt",
        "kms:GenerateDataKey*",
      ]
    }

  }
}

# -----------------------------------------------------------
# Configuration for AWS Config Aggregator
# -----------------------------------------------------------

resource "aws_config_configuration_aggregator" "this" {
  count = var.is_aggregator ? 1 : 0

  name = format("%s-%s-%02d", "cfag", var.name, 1)

  account_aggregation_source {
    regions     = var.config_aggregate_enable_all_regions != true ? local.config_aggregate_regions : null
    all_regions = var.config_aggregate_enable_all_regions
    account_ids = var.config_aggregate_account_ids
  }
}

# -----------------------------------------------------------
# Configuration for an aggregated AWS Config account
# -----------------------------------------------------------
resource "aws_config_aggregate_authorization" "this" {
  count = var.aggregator_account_id != null ? 1 : 0

  account_id = var.aggregator_account_id
  region     = data.aws_region.current.name

  tags = local.tags
}

# -----------------------------------------------------------
# AWS Config Rules
# -----------------------------------------------------------
resource "aws_config_config_rule" "rules" {
  for_each = var.config_rules

  name = each.key

  source {
    owner             = lookup(each.value, "owner", "AWS")
    source_identifier = each.value["source_identifier"]
    dynamic "source_detail" {
      for_each = lookup(each.value, "owner", "AWS") != "AWS" ? [1] : []
      content {
        event_source                = lookup(each.value, "event_source", null)
        maximum_execution_frequency = lookup(each.value, "maximum_execution_frequency", null)
        message_type                = lookup(each.value, "message_type", null)
      }
    }
  }

  maximum_execution_frequency = lookup(each.value, "maximum_execution_frequency", null)
  input_parameters            = lookup(each.value, "input_parameters", null) != null ? jsonencode(lookup(each.value, "input_parameters", null)) : null

  depends_on = [aws_config_configuration_recorder.this]
}
