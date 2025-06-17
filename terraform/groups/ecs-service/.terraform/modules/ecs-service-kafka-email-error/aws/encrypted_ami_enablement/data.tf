data "aws_iam_role" "service" {
  for_each = local.role_names_map

  name = each.value
}
