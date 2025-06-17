
########################
# Proxy resources
########################
resource "aws_security_group" "this" {
  name        = format("%s-%s-%02d", "sgr", var.name, 1)
  vpc_id      = var.vpc_id
  description = "Controls access to proxy instances"
  tags        = local.tags
}

resource "aws_security_group_rule" "proxy_http_ingress" {
  count = length(var.proxy_http_ingress_ports)

  description       = "TF Managed: Egress proxy HTTP/S ingress traffic"
  type              = "ingress"
  from_port         = var.proxy_http_ingress_ports[count.index]
  to_port           = var.proxy_http_ingress_ports[count.index]
  protocol          = "TCP"
  cidr_blocks       = var.proxy_http_ingress_cidrs
  security_group_id = aws_security_group.this.id
}

resource "aws_security_group_rule" "proxy_mgmt_ingress" {
  count = length(var.proxy_mgmt_ingress_ports)

  description       = "TF Managed: Egress proxy management ingress traffic"
  type              = "ingress"
  from_port         = var.proxy_mgmt_ingress_ports[count.index]
  to_port           = var.proxy_mgmt_ingress_ports[count.index]
  protocol          = "TCP"
  cidr_blocks       = var.proxy_mgmt_ingress_cidrs
  security_group_id = aws_security_group.this.id
}

resource "aws_security_group_rule" "app_egress" {
  description       = "TF Managed: Egress proxy egress traffic"
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"] #tfsec:ignore:AWS007
  security_group_id = aws_security_group.this.id
}

########################
# Lambda resources
########################
resource "aws_security_group" "lambda" {
  name        = format("%s-%s-%02d", "sgr", var.name, 2)
  vpc_id      = var.vpc_id
  description = "Controls failover lambda access"
  tags        = local.tags
}

resource "aws_security_group_rule" "lambda_egress" {
  description       = "TF Managed: Egress proxy failover lambda egress traffic"
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"] #tfsec:ignore:AWS007
  security_group_id = aws_security_group.lambda.id
}
