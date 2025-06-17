########################
# Lambda resources
########################
data "template_file" "lambda_code" {
  template = file("${path.module}/templates/failover_lambda.py.tpl")
  vars = {
    ALARMPREFIX = var.name
    ALARMTOPIC  = aws_sns_topic.this.arn
  }
}

data "archive_file" "lambda_code" {
  type        = "zip"
  output_path = local.lambda_package_file_name

  source {
    content  = data.template_file.lambda_code.rendered
    filename = "${local.lambda_file_name}.py"
  }
}

resource "aws_lambda_function" "this" {
  function_name    = local.lambda_function_name
  description      = "Squid Proxy failover controller"
  runtime          = "python3.7"
  handler          = "${local.lambda_file_name}.handler"
  filename         = local.lambda_package_file_name
  source_code_hash = data.archive_file.lambda_code.output_base64sha256
  timeout          = var.lambda_timeout
  role             = aws_iam_role.lambda.arn

  vpc_config {
    subnet_ids         = var.private_subnet_ids
    security_group_ids = [aws_security_group.lambda.id]
  }
  depends_on = [aws_iam_role_policy_attachment.lambda]
}

resource "aws_cloudwatch_log_group" "lambda_logs" {
  name              = "/aws/lambda/${local.lambda_function_name}"
  retention_in_days = var.log_group_retention_in_days
}


########################
# Lambda SNS trigger resources
########################
resource "aws_sns_topic" "this" { #tfsec:ignore:AWS016
  name = "sns-${var.name}-ec2-alerts"
}

resource "aws_sns_topic_subscription" "lambda" {
  topic_arn = aws_sns_topic.this.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.this.arn
}

resource "aws_lambda_permission" "lambda" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.this.arn
}

resource "aws_cloudwatch_metric_alarm" "this" {
  count = var.enable_failover ? length(var.private_subnet_ids) : 0

  alarm_name          = "${var.name}/${aws_autoscaling_group.this[count.index].name}"
  alarm_actions       = [aws_sns_topic.this.arn]
  ok_actions          = [aws_sns_topic.this.arn]
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "procstat_cpu_usage"
  namespace           = "CWAgent"
  period              = "10"
  statistic           = "Average"
  threshold           = "0.0"
  treat_missing_data  = "breaching"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.this[count.index].name
    pidfile              = "/var/run/squid.pid"
    process_name         = "squid"
  }

  depends_on = [aws_lambda_function.this, aws_sns_topic_subscription.lambda]
}
