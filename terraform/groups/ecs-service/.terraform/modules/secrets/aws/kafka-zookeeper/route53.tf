resource "aws_route53_record" "zookeeper" {
  for_each = var.route53_available ? local.instance_definitions : {}

  zone_id = data.aws_route53_zone.zone[0].zone_id
  name    = each.value.hostname
  type    = "A"
  ttl     = "300"
  records = [aws_instance.zookeepers[each.key].private_ip]
}

resource "aws_route53_record" "certificate_validation" {
  count   = var.route53_available ? 1 : 0

  zone_id = data.aws_route53_zone.zone[0].zone_id
  name    = tolist(aws_acm_certificate.certificate[0].domain_validation_options)[0].resource_record_name
  type    = tolist(aws_acm_certificate.certificate[0].domain_validation_options)[0].resource_record_type
  records = [
    tolist(aws_acm_certificate.certificate[0].domain_validation_options)[0].resource_record_value
  ]
  ttl     = 60
}

resource "aws_route53_record" "cmak_load_balancer" {
  count   = var.route53_available ? 1 : 0

  zone_id = data.aws_route53_zone.zone[0].zone_id
  name    = local.cmak_load_balancer_dns_name
  type    = "A"

  alias {
    name                   = aws_lb.cmak.dns_name
    zone_id                = aws_lb.cmak.zone_id
    evaluate_target_health = false
  }
}
