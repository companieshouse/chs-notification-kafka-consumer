locals {
  tags = merge(var.tags, {terraform = true})


  s3_firewall_logs = { for log, bucket in {
      "FLOW" = var.firewall_flow_logs_bucket_name
      "ALERT" = var.firewall_alert_logs_bucket_name
    } : log => bucket if bucket != null
  }

  cloudwatch_firewall_logs = { for log, enabled in {
      "FLOW" = var.enable_firewall_cloudwatch_flow_logs
      "ALERT" = var.enable_firewall_cloudwatch_alert_logs
    } : log => lower(format("%s_%s_logs", var.name, log)) if enabled != false
  }

  managed_rule_group_arns = var.managed_rule_group_arns
}

resource "aws_networkfirewall_firewall" "firewall" {
  name                = var.name
  firewall_policy_arn = aws_networkfirewall_firewall_policy.firewall_policy.arn
  vpc_id              = var.vpc_id

  firewall_policy_change_protection = var.firewall_policy_change_protection
  subnet_change_protection          = var.subnet_change_protection
  delete_protection                 = var.firewall_delete_protection

  dynamic "subnet_mapping" {
    for_each = var.firewall_endpoint_subnets
    content {
      subnet_id = subnet_mapping.value
    }
  }
  tags = local.tags
}


resource "aws_networkfirewall_firewall_policy" "firewall_policy" {
  name = format("%spolicy", var.name)
  firewall_policy {
    stateless_default_actions          = [var.stateless_default_actions]
    stateless_fragment_default_actions = [var.stateless_fragment_default_actions]

    stateful_default_actions = var.filewall_stateful_engine_evaluation_order == "STRICT_ORDER" ? var.stateful_default_actions : null

    stateful_engine_options {
      rule_order = var.filewall_stateful_engine_evaluation_order
    }

    dynamic "stateless_rule_group_reference" {
      for_each = var.stateless_rule_groups
      content {
        priority     = stateless_rule_group_reference.key
        resource_arn = stateless_rule_group_reference.value
      }
    }

    dynamic "stateful_rule_group_reference" {
      for_each = var.domain_rule_groups
      content {
        priority     = var.filewall_stateful_engine_evaluation_order == "STRICT_ORDER" ? stateful_rule_group_reference.key : null
        resource_arn = stateful_rule_group_reference.value
      }
    }

    dynamic "stateful_rule_group_reference" {
      for_each = local.managed_rule_group_arns
      content {
        priority     = var.filewall_stateful_engine_evaluation_order == "STRICT_ORDER" ? index(local.managed_rule_group_arns, stateful_rule_group_reference.value) + 1 : null
        resource_arn = stateful_rule_group_reference.value
      }
    }
  }
  
  tags = local.tags
}

resource "aws_networkfirewall_logging_configuration" "firewall_logs" {

  firewall_arn = aws_networkfirewall_firewall.firewall.arn



  logging_configuration {
    dynamic "log_destination_config" {
      for_each = local.s3_firewall_logs
      content {
        log_destination = {
          bucketName = log_destination_config.value
          prefix     = lower(format("%s_%s", var.name, log_destination_config.key))
        }
        log_destination_type = "S3"
        log_type             = log_destination_config.key
      }
    }
    
    dynamic "log_destination_config" {
      for_each = local.cloudwatch_firewall_logs
      content {        
        log_destination = {
          logGroup = log_destination_config.value
        }
        log_destination_type = "CloudWatchLogs"
        log_type             = log_destination_config.key
      }
    }
  }
}

data "aws_kms_key" "cloudwatch_kms_key" {
  count = var.cloudwatch_kms_key == null ? 0 : 1

  key_id = var.cloudwatch_kms_key
}

resource "aws_cloudwatch_log_group" "firewall_alerts_log_group" {
  name = format("%s_alert_logs", var.name)

  retention_in_days = var.cloudwatch_log_retention_days

  kms_key_id = var.cloudwatch_kms_key == null ? null : data.aws_kms_key.cloudwatch_kms_key[0].arn

  tags = local.tags
}
