resource "aws_security_group" "rds" {
  name        = "${local.rds_identifier}-rds"
  description = "Security group for ${local.rds_identifier}"
  vpc_id      = var.vpc_id

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.default_tags,
    {
      Name = "${local.rds_identifier}-rds"
    }
  )
}

resource "aws_security_group_rule" "ingress_cidrs" {
  for_each = toset(var.ingress_cidrs)

  description       = "Permit RDS access from ${each.value}"
  type              = "ingress"
  from_port         = local.port
  to_port           = local.port
  protocol          = "tcp"
  cidr_blocks       = [each.value]
  security_group_id = aws_security_group.rds.id
}

resource "aws_security_group_rule" "ingress_prefix_lists" {
  for_each = toset(var.ingress_prefix_list_ids)

  description       = "Permit RDS access from ${each.value}"
  type              = "ingress"
  from_port         = local.port
  to_port           = local.port
  protocol          = "tcp"
  prefix_list_ids   = [each.value]
  security_group_id = aws_security_group.rds.id
}

resource "aws_security_group_rule" "ingress_security_groups" {
  for_each = toset(var.ingress_security_group_ids)

  description              = "Permit RDS access from ${each.value}"
  type                     = "ingress"
  from_port                = local.port
  to_port                  = local.port
  protocol                 = "tcp"
  source_security_group_id = each.value
  security_group_id        = aws_security_group.rds.id
}
