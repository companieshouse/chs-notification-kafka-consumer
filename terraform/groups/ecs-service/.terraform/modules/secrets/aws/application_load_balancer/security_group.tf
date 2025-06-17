resource "aws_security_group" "sg" {
  count = var.create_security_group ? 1 : 0

  name        = "sgr-${var.environment}-${var.service}"
  description = "Security group for alb-${var.environment}-${var.service}"
  vpc_id      = var.vpc_id

  tags = {
    Environment = var.environment
    Service     = var.service
    Name        = "sgr-${var.environment}-${var.service}"
  }
}

resource "aws_security_group_rule" "egress" {
  for_each = var.create_security_group ? {
    for idx, cidr in var.egress_cidrs : idx => cidr
  } : {}

  description       = "Egress rule for ${each.value}"
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = [each.value]
  security_group_id = aws_security_group.sg[0].id
}

resource "aws_security_group_rule" "ingress_http_cidrs" {
  for_each = var.create_security_group && var.redirect_http_to_https && length(var.ingress_cidrs) > 0 ? {
    for idx, cidr in var.ingress_cidrs : idx => cidr
  } : {}

  description       = "Allow HTTP from ${each.value}"
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = [each.value]
  security_group_id = aws_security_group.sg[0].id
}

resource "aws_security_group_rule" "ingress_http_prefix" {
  for_each = var.create_security_group && var.redirect_http_to_https && length(var.ingress_prefix_list_ids) > 0 ? {
    for idx, id in var.ingress_prefix_list_ids : idx => id
  } : {}

  description       = "Allow HTTP from ${each.value}"
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  prefix_list_ids   = [each.value]
  security_group_id = aws_security_group.sg[0].id
}

resource "aws_security_group_rule" "ingress_https_cidrs" {
  for_each = var.create_security_group && length(var.ingress_cidrs) > 0 ? {
    for idx, cidr in var.ingress_cidrs : idx => cidr
  } : {}

  description       = "Allow HTTPS from ${each.value}"
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = [each.value]
  security_group_id = aws_security_group.sg[0].id
}

resource "aws_security_group_rule" "ingress_https_prefix" {
  for_each = var.create_security_group && length(var.ingress_prefix_list_ids) > 0 ? {
    for idx, id in var.ingress_prefix_list_ids : idx => id
  } : {}

  description       = "Allow HTTPS from ${each.value}"
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  prefix_list_ids   = [each.value]
  security_group_id = aws_security_group.sg[0].id
}
