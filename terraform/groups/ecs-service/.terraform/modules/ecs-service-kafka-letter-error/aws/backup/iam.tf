resource "aws_iam_role" "backup_service_role" {
  name               = "${var.environment}-backup-service"
  description        = "Allows the AWS Backup Service to take scheduled backups"
  assume_role_policy = data.aws_iam_policy_document.backup_service_trust.json

  tags = local.infrastructure_tags
}

resource "aws_iam_role" "restore_service_role" {
  name               = "${var.environment}-restore-service"
  description        = "Allows the AWS Backup Service to restore scheduled backups"
  assume_role_policy = data.aws_iam_policy_document.backup_service_trust.json

  tags = local.infrastructure_tags
}

resource "aws_iam_role_policy" "backup_service" {
  policy = data.aws_iam_policy.backup_service_policy.policy
  role   = aws_iam_role.backup_service_role.name
}

resource "aws_iam_role_policy" "backup_service_pass_role" {
  policy = data.aws_iam_policy_document.backup_pass_role.json
  role   = aws_iam_role.backup_service_role.name
}

resource "aws_iam_role_policy" "restore_service" {
  policy = data.aws_iam_policy.restore_service_policy.policy
  role   = aws_iam_role.restore_service_role.name
}

resource "aws_iam_role_policy" "restore_service_pass_role" {
  policy = data.aws_iam_policy_document.backup_pass_role.json
  role   = aws_iam_role.restore_service_role.name
}
