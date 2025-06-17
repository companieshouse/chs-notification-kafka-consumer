data "aws_subnet" "deployment" {
  for_each = toset(var.subnet_ids)

  id = each.value
}

data "aws_iam_policy_document" "access" {
  statement {
    sid    = "AllowClientAccess"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = concat(
      [
        "elasticfilesystem:ClientMount",
        "elasticfilesystem:ClientWrite"
      ],
      local.file_system_client_root_access
    )

    resources = [
      aws_efs_file_system.efs.arn
    ]
  }
}
