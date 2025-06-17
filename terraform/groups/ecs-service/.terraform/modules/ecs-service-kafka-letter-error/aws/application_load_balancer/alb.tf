resource "aws_lb" "alb" {
  name                       = "alb-${var.environment}-${var.service}"
  load_balancer_type         = "application"

  enable_deletion_protection = var.enable_deletion_protection
  idle_timeout               = var.idle_timeout
  internal                   = var.internal
  preserve_host_header       = var.preserve_host_header
  security_groups            = local.security_group_ids
  subnets                    = var.subnet_ids

  tags = {
    Environment = var.environment
    Service     = var.service
    Name        = "alb-${var.environment}-${var.service}"
    ALB         = "true"
  }
}

resource "aws_lb_listener" "http" {
  count = var.redirect_http_to_https ? 1 : 0

  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "listeners" {
  for_each = {
    for service, config in var.service_configuration : service => config["listener_config"] if service == "listener_config"
  }

  load_balancer_arn = aws_lb.alb.arn
  port              = each.value["port"]
  protocol          = "HTTPS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.ssl_certificate_arn

  dynamic "default_action" {
    for_each = each.value["default_action_type"] == "fixed-response" ? [1] : []

    content {
      type           = each.value["default_action_type"]

      fixed_response {
        content_type = lookup(each.value["fixed_response"], "content_type")
        message_body = lookup(each.value["fixed_response"], "message_body")
        status_code  = lookup(each.value["fixed_response"], "status_code")
      }
    }
  }

  dynamic "default_action" {
    for_each = each.value["default_action_type"] == "forward" ? [1] : []

    content {
      type             = each.value["default_action_type"]
      target_group_arn = aws_lb_target_group.tg[each.key].arn
    }
  }
}

resource "aws_lb_target_group" "tg" {
  for_each = {
    for service, config in var.service_configuration : service => config["target_group_config"]
    if lookup(config["listener_config"], "default_action_type") == "forward"
  }

  name        = "tg-${var.environment}-${var.service}-${each.value["port"]}"

  port        = each.value["port"]
  protocol    = each.value["protocol"]
  target_type = each.value["target_type"]
  vpc_id      = var.vpc_id

  health_check {
    healthy_threshold   = lookup(each.value["health_check"], "healthy_threshold")
    unhealthy_threshold = lookup(each.value["health_check"], "unhealthy_threshold")
    interval            = lookup(each.value["health_check"], "interval")
    matcher             = lookup(each.value["health_check"], "matcher")
    path                = lookup(each.value["health_check"], "path")
    port                = lookup(each.value["health_check"], "port")
    protocol            = lookup(each.value["health_check"], "protocol")
    timeout             = lookup(each.value["health_check"], "timeout")
  }
}
