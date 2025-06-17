locals {
  security_group_ids = var.create_security_group ? concat([aws_security_group.sg[0].id], var.security_group_ids) : var.security_group_ids
  fq_domain                       = "${var.route53_domain_name}."
}
