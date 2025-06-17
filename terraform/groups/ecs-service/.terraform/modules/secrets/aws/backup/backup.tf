resource "aws_backup_vault" "backup_vault" {
  name = "${var.environment}-backup-vault"

  tags = local.infrastructure_tags
}

resource "aws_backup_plan" "backup_plans" {
  for_each = var.backup_retentions_days

  name = "${var.environment}-${each.key}-days"

  rule {
    rule_name         = "${each.key}-day-retention-period"
    target_vault_name = aws_backup_vault.backup_vault.name
    schedule          = var.cron_schedule_expression
    start_window      = var.start_window_minutes
    completion_window = var.completion_window_minutes

    lifecycle {
      delete_after = each.key
    }

    recovery_point_tags = merge(
      local.infrastructure_tags,
      {
        "Creator"    = "aws-backups",
        "BackupPlan" = "backup-${each.key}-days"
      }
    )
  }

  tags = local.infrastructure_tags
}

resource "aws_backup_selection" "backup_selections" {
  for_each = var.backup_retentions_days

  iam_role_arn = aws_iam_role.backup_selection_role.arn
  name         = "${var.environment}-${each.key}-backup-resources"
  plan_id      = aws_backup_plan.backup_plans[each.key].id

  not_resources = []
  condition {}

  selection_tag {
    type  = "STRINGEQUALS"
    key   = "Backup"
    value = "backup${each.key}"
  }
}
