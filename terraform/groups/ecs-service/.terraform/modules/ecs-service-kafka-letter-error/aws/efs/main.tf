resource "aws_efs_file_system" "efs" {
  creation_token   = "${local.service_name_prefix}-efs"
  encrypted        = true
  kms_key_id       = var.kms_key_arn
  performance_mode = var.performance_mode
  throughput_mode  = var.throughput_mode

  tags = merge(
    local.default_tags,
    {
      Name = "${local.service_name_prefix}-efs"
    }
  )
}

resource "aws_efs_file_system_policy" "efs" {
  file_system_id = aws_efs_file_system.efs.id
  policy         = data.aws_iam_policy_document.access.json
}

resource "aws_efs_access_point" "efs" {
  for_each = var.access_points

  file_system_id = aws_efs_file_system.efs.id

  posix_user {
    gid = each.value.posix_user_gid
    uid = each.value.posix_user_uid
  }

  root_directory {
    path = each.value.root_directory
    creation_info {
      owner_gid   = each.value.posix_user_gid
      owner_uid   = each.value.posix_user_uid
      permissions = each.value.permissions
    }
  }

  tags = merge(
    local.default_tags,
    {
      Name = "${local.service_name_prefix}-${replace(each.key, "_", "-")}"
    }
  )
}

resource "aws_efs_mount_target" "efs" {
  for_each = data.aws_subnet.deployment

  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = each.value.id
  security_groups = [aws_security_group.efs.id]
}

resource "aws_security_group" "efs" {
  name        = "${local.service_name_prefix}-efs"
  description = "EFS security group for ${local.service_name_prefix}"
  vpc_id      = var.vpc_id

  tags = merge(
    local.default_tags,
    {
      Name = "${local.service_name_prefix}-efs"
    }
  )
}

resource "aws_security_group_rule" "efs_deployment" {
  for_each = var.ingress_from_deployment_subnets ? data.aws_subnet.deployment : {}

  type              = "ingress"
  from_port         = 2049
  to_port           = 2049
  protocol          = "tcp"
  cidr_blocks       = [each.value.cidr_block]
  security_group_id = aws_security_group.efs.id
}

resource "aws_security_group_rule" "efs_cidrs" {
  for_each = length(var.ingress_cidrs) > 0 ? {
    for idx, cidr in var.ingress_cidrs : "cidr_${idx}" => cidr
  } : {}

  type              = "ingress"
  from_port         = 2049
  to_port           = 2049
  protocol          = "tcp"
  cidr_blocks       = [each.value]
  security_group_id = aws_security_group.efs.id
}

resource "aws_security_group_rule" "efs_prefix_lists" {
  for_each = length(var.ingress_prefix_list_ids) > 0 ? {
    for idx, pl in var.ingress_prefix_list_ids : "pl_${idx}" => pl
  } : {}

  type              = "ingress"
  from_port         = 2049
  to_port           = 2049
  protocol          = "tcp"
  prefix_list_ids   = [each.value]
  security_group_id = aws_security_group.efs.id
}

resource "aws_security_group_rule" "efs_security_groups" {
  for_each = length(var.ingress_security_group_ids) > 0 ? {
    for idx, sg in var.ingress_security_group_ids : "sg_${idx}" => sg
  } : {}

  type                     = "ingress"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "tcp"
  security_group_id        = aws_security_group.efs.id
  source_security_group_id = each.value
}
