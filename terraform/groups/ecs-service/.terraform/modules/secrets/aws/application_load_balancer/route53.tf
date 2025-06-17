resource "aws_route53_record" "alias" {
  for_each = toset(var.route53_aliases) 

  zone_id = data.aws_route53_zone.zone[0].zone_id 
  name    = "${each.key}.${var.environment}.${var.route53_domain_name}"
  type    = "A"

  alias {
    name                   = aws_lb.alb.dns_name
    zone_id                = aws_lb.alb.zone_id
    evaluate_target_health = false
  }
}
