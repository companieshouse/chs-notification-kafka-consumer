resource "aws_acm_certificate" "certificate" {
  count                     = var.route53_available ? 1 : 0

  domain_name               = "${var.service}-${var.environment}-cmak.${var.load_balancer_dns_zone_name}"
  subject_alternative_names = ["*.${var.service}-${var.environment}-cmak.${var.load_balancer_dns_zone_name}"]
  validation_method         = "DNS"
}

resource "aws_acm_certificate_validation" "certificate" {
  count                   = var.route53_available ? 1 : 0

  certificate_arn         = aws_acm_certificate.certificate[0].arn
  validation_record_fqdns = [aws_route53_record.certificate_validation[0].fqdn]
}

resource "aws_lb" "cmak" {
  name                       = "${var.service}-${var.environment}-cmak"
  internal                   = true
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.cmak_load_balancer.id]
  subnets                    = values(var.subnets).*.id
  enable_deletion_protection = false

  tags = {
    Environment = var.environment
    Service     = var.service
    Name        = "${var.service}-${var.environment}-cmak"
    Type        = "ApplicationLoadBalancer"
  }
}

resource "aws_lb_target_group" "cmak" {
  name        = "${var.service}-${var.environment}-cmak"
  port        = 9000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    path                = "/api/health"
    interval            = 60
  }
}

resource "aws_lb_target_group_attachment" "cmak" {
  for_each = local.instance_definitions

  target_group_arn = aws_lb_target_group.cmak.arn
  target_id        = aws_instance.zookeepers[each.key].private_ip
  port             = 9000
}

resource "aws_lb_listener" "cmak" {
  load_balancer_arn = aws_lb.cmak.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = local.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.cmak.arn
  }

  depends_on = [
    aws_acm_certificate_validation.certificate
  ]
}
