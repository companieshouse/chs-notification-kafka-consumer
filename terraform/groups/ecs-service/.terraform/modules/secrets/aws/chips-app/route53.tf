resource "aws_route53_record" "app" {
  zone_id = data.aws_route53_zone.private_zone.zone_id
  name    = var.application
  type    = "A"

  alias {
    name                   = module.internal_alb.lb_dns_name
    zone_id                = module.internal_alb.lb_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "admin" {
  count   = var.asg_count
  zone_id = data.aws_route53_zone.private_zone.zone_id
  name    = "${var.application}-admin-${count.index}"
  type    = "A"

  alias {
    name                   = module.internal_alb.lb_dns_name
    zone_id                = module.internal_alb.lb_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "nlb" {
  count   = var.create_nlb ? 1 : 0
  zone_id = data.aws_route53_zone.private_zone.zone_id
  name    = "chips-cc-nlb"
  type    = "A"

  alias {
    name                   = aws_lb.nlb[0].dns_name
    zone_id                = aws_lb.nlb[0].zone_id
    evaluate_target_health = true
  }
}
