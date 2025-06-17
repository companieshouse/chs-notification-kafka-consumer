
########################
# Proxy IAM resources
########################
resource "aws_iam_role" "this" {
  name               = format("%s-%s-%02d", "irol", var.name, 1)
  tags               = local.tags
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "this_ssm" {
  count      = var.enable_ssm ? 1 : 0
  role       = aws_iam_role.this.name
  policy_arn = data.aws_iam_policy.ssm[0].arn
}

resource "aws_iam_policy" "this" {
  name   = format("%s-%s-%02d", "ipol", var.name, 1)
  policy = data.aws_iam_policy_document.this.json
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}


resource "aws_iam_instance_profile" "this" {
  name = format("%s-%s-%02d", "ipro", var.name, 1)
  role = aws_iam_role.this.name
}

data "aws_iam_policy_document" "this" {

  dynamic "statement" {
    for_each = var.ssm_logs_bucket != null ? (var.enable_ssm ? [1] : []) : []
    content {
      sid    = "S3writeoperations"
      effect = "Allow"
      resources = [
        format("arn:aws:s3:::%s", var.ssm_logs_bucket),
        format("arn:aws:s3:::%s/*", var.ssm_logs_bucket),
      ]
      actions = [
        "s3:PutObject",
        "s3:PutObjectACL",
      ]
    }
  }

  dynamic "statement" {
    for_each = var.ssm_logs_kms_key != null ? (var.enable_ssm ? [1] : []) : []
    content {
      sid    = "SSMLogsKMSOperations"
      effect = "Allow"
      resources = [
        for key in data.aws_kms_key.ssm_logs_kms_key : key.arn
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
    for_each = var.ssm_session_kms_key != null ? (var.enable_ssm ? [1] : []) : []
    content {
      sid    = "SSMSessionKMSOperations"
      effect = "Allow"
      resources = [
        for key in data.aws_kms_key.ssm_session_kms_key : key.arn
      ]
      actions = [
        "kms:Decrypt",
      ]
    }
  }

  dynamic "statement" {
    for_each = var.cloudwatch_logs_to_collect != null ? [1] : []
    content {
      sid    = "CloudwatchLogsStreaming"
      effect = "Allow"
      resources = flatten([
        formatlist(
          "arn:aws:logs:%s:%s:log-group:%s:*",
          data.aws_region.current.name,
          data.aws_caller_identity.current.account_id,
          var.cloudwatch_logs_to_collect
        ),
        formatlist(
          "arn:aws:logs:%s:%s:log-group:%s:*:*",
          data.aws_region.current.name,
          data.aws_caller_identity.current.account_id,
          var.cloudwatch_logs_to_collect
        )
      ])
      actions = [
        "logs:CreateLogStream",
        "logs:PutLogEvents",
      ]
    }
  }

  statement {
    sid       = "CloudwatchMetrics"
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "ec2:DescribeTags",
      "cloudwatch:PutMetricData",
    ]
  }

  statement {
    sid       = "SourceCheckDisable"
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "ec2:ModifyInstanceAttribute",
    ]
  }

  dynamic "statement" {
    for_each = var.custom_iam_statements != null ? var.custom_iam_statements : []
    content {
      sid       = statement.value["sid"]
      effect    = statement.value["effect"]
      resources = statement.value["resources"]
      actions   = statement.value["actions"]
    }
  }
}


########################
# Lambda IAM resources
########################
resource "aws_iam_role" "lambda" {
  name = format("%s-%s-%02d", "irol", var.name, 2)

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda" {
  role       = aws_iam_role.lambda.name
  policy_arn = aws_iam_policy.lambda.arn
}

resource "aws_iam_policy" "lambda" {
  name   = format("%s-%s-%02d", "ipol", var.name, 2)
  policy = data.aws_iam_policy_document.lambda.json
}

# TODO fix resources
data "aws_iam_policy_document" "lambda" {
  statement {
    sid       = "LambdaVPC"
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface",
      "ec2:AssignPrivateIpAddresses",
      "ec2:UnassignPrivateIpAddresses",
    ]
  }
  statement {
    sid    = "CloudwatchLogsStreaming"
    effect = "Allow"
    resources = [
      format("%s:*:*", aws_cloudwatch_log_group.lambda_logs.arn),
    ]
    actions = [
      # "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
  }
  statement {
    sid       = "AllowRouteTableUpdates"
    effect    = "Allow"
    resources = formatlist("arn:aws:ec2:%s:%s:route-table/%s", data.aws_region.current.name, data.aws_caller_identity.current.account_id, var.ingress_route_table_ids)
    actions = [
      "ec2:CreateRoute",
      "ec2:ReplaceRoute",
      "ec2:CreateTags",
    ]
  }
  statement {
    sid       = "DescribeActions"
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "cloudwatch:Describe*",
      "ec2:Describe*",
      "autoscaling:Describe*",
    ]
  }
  statement {
    sid       = ""
    effect    = "Allow"
    resources = aws_autoscaling_group.this.*.arn
    actions = [
      "autoscaling:CompleteLifecycleAction",
      "autoscaling:SetInstanceHealth",
    ]
  }
}
