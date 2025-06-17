data "aws_db_instance" "this" {
  count = var.rds_schedule_enable ? 1 : 0

  db_instance_identifier = var.rds_instance_id
}

data "aws_iam_policy_document" "this" {
  count = var.rds_schedule_enable ? 1 : 0

  statement {
    sid       = "RDSStartStop"
    actions   = [
      "rds:Describe*",
      "rds:Start*",
      "rds:Stop*",
      "rds:Reboot*",
    ]
    effect    = "Allow"
    resources = [data.aws_db_instance.this[0].db_instance_arn]
  }
}

resource "aws_iam_role" "this" {
  count = var.rds_schedule_enable ? 1 : 0

  name               = "irol-${var.rds_instance_id}-start-stop"
  description        = "Allows SSM to start and stop ${var.rds_instance_id}"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = "AssumeRDSStartStopRole"
        Principal = {
          Service = "ssm.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "this" {
  count = var.rds_schedule_enable ? 1 : 0

  name   = "ipol-${var.rds_instance_id}-start-stop"
  role   = aws_iam_role.this[0].name
  policy = data.aws_iam_policy_document.this[0].json
}

resource "aws_ssm_association" "this_stop" {
  count = var.rds_schedule_enable ? 1 : 0

  association_name                 = "ssm-${var.rds_instance_id}-stop"
  name                             = "AWS-StopRdsInstance"
  apply_only_at_cron_interval      = true
  automation_target_parameter_name = "InstanceId"
  schedule_expression              = var.rds_stop_schedule

  parameters = {
    AutomationAssumeRole = aws_iam_role.this[0].arn
    InstanceId           = var.rds_instance_id
  }

  targets {
    key    = "tag:Name"
    values = [var.rds_instance_id]
  }

  depends_on = [
    aws_iam_role.this[0],
  ]
}

resource "aws_ssm_association" "this_start" {
  count = var.rds_schedule_enable ? 1 : 0

  association_name                 = "ssm-${var.rds_instance_id}-start"
  name                             = "AWS-StartRdsInstance"
  apply_only_at_cron_interval      = true
  automation_target_parameter_name = "InstanceId"
  schedule_expression              = var.rds_start_schedule

  parameters = {
    AutomationAssumeRole = aws_iam_role.this[0].arn
    InstanceId           = var.rds_instance_id
  }

  targets {
    key    = "tag:Name"
    values = [var.rds_instance_id]
  }

  depends_on = [
    aws_iam_role.this[0],
  ]
}
