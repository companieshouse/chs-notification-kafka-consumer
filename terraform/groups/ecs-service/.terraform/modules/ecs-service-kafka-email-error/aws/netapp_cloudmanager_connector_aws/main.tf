resource "aws_security_group" "this" {
  name        = format("%s-%s", "sgr", var.name)
  description = "Control Inbound and Outbound access to NetApp Connector instance"
  vpc_id      = var.vpc_id

  tags = merge(
    map(
      "Name", format("%s-%s", "sgr", var.name),
      "Terraform", "true",
    ),
    var.tags,
  )
}

resource "aws_security_group_rule" "internal" {
  description       = "Allow all traffic between members of this SG for inter node communications"
  security_group_id = aws_security_group.this.id
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  self              = true
}

resource "aws_security_group_rule" "ingress_cidrs" {
  count = length(var.ingress_cidr_blocks) >= 1 ? length(var.ingress_ports) : 0

  description       = "Allow ingress traffic on specified ports"
  security_group_id = aws_security_group.this.id
  type              = "ingress"
  from_port         = var.ingress_ports[count.index]["port"]
  to_port           = lookup(var.ingress_ports[count.index], "to_port", var.ingress_ports[count.index]["port"])
  protocol          = var.ingress_ports[count.index]["protocol"]
  cidr_blocks       = var.ingress_cidr_blocks
}

resource "aws_security_group_rule" "egress_cidrs" {
  count = length(var.egress_cidr_blocks) >= 1 ? length(var.egress_ports) : 0

  description       = "Allow egress traffic from CVO instances"
  security_group_id = aws_security_group.this.id
  type              = "egress"
  from_port         = var.egress_ports[count.index]["port"]
  to_port           = lookup(var.egress_ports[count.index], "to_port", var.egress_ports[count.index]["port"])
  protocol          = var.egress_ports[count.index]["protocol"]
  cidr_blocks       = var.egress_cidr_blocks #tfsec:ignore:AWS007
}

resource "aws_security_group_rule" "ingress_sgs" {
  count = length(local.ingress_sgs)

  description              = "Allow ingress traffic on specified ports"
  security_group_id        = aws_security_group.this.id
  type                     = "ingress"
  from_port                = local.ingress_sgs[count.index][1]["port"]
  to_port                  = lookup(local.ingress_sgs[count.index][1], "to_port", local.ingress_sgs[count.index][1]["port"])
  protocol                 = local.ingress_sgs[count.index][1]["protocol"]
  source_security_group_id = local.ingress_sgs[count.index][0]
}

resource "aws_security_group_rule" "egress_sgs" {
  count = length(local.egress_sgs)

  description              = "Allow egress traffic on specified ports"
  security_group_id        = aws_security_group.this.id
  type                     = "egress"
  from_port                = local.egress_sgs[count.index][1]["port"]
  to_port                  = lookup(local.egress_sgs[count.index][1], "to_port", local.egress_sgs[count.index][1]["port"])
  protocol                 = local.egress_sgs[count.index][1]["protocol"]
  source_security_group_id = local.egress_sgs[count.index][0]
}

resource "netapp-cloudmanager_connector_aws" "this" {
  count = var.build_connector == true ? 1 : 0

  name                        = var.name
  region                      = data.aws_region.current.name
  key_name                    = var.key_pair_name
  company                     = var.company_name
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  associate_public_ip_address = var.set_public_ip
  security_group_id           = aws_security_group.this.id
  iam_instance_profile_name   = aws_iam_instance_profile.this.name
  account_id                  = var.netapp_account_id

  depends_on = [
    aws_iam_instance_profile.this,
  ]

}
