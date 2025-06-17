data "aws_route53_zone" "zone" {
  count = length(var.route53_aliases) > 0 ? 1 : 0
  name  = local.fq_domain
}
