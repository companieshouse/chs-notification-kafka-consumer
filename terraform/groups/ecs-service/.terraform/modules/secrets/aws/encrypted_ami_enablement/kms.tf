resource "aws_kms_grant" "ebs_kms" {
  for_each = local.role_names_map

  name              = "${var.aws_account}-${each.key}-kms-${var.kms_key_region}-grant"
  key_id            = var.kms_key_arn
  grantee_principal = data.aws_iam_role.service[each.key].arn
  operations        = local.kms_operations
}
