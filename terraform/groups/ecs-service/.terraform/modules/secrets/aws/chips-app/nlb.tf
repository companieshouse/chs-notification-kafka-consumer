resource "aws_lb" "nlb" {
  count              = var.create_nlb ? 1 : 0
  name               = "nlb-${var.application}-int-1"
  internal           = true
  load_balancer_type = "network"

  dynamic "subnet_mapping" {
    for_each = local.nlb_subnet_mapping_list

    content {
      subnet_id            = subnet_mapping.value.subnet_id
      private_ipv4_address = lookup(subnet_mapping.value, "private_ipv4_address", null)
    }
  }

  enable_deletion_protection = false
}

resource "aws_lb_target_group" "nlb_https" {
  count                = var.create_nlb ? 1 : 0
  name                 = "tg-${var.application}-nlb-https-1"
  vpc_id               = data.aws_vpc.vpc.id
  port                 = 443
  protocol             = "TCP"
  target_type          = "alb"
  deregistration_delay = 60
  preserve_client_ip   = true

  health_check {
    enabled             = true
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2
    protocol            = "HTTPS"
  }
}

resource "aws_lb_target_group_attachment" "alb_to_nlb_https" {
  count                = var.create_nlb ? 1 : 0
  target_group_arn     = aws_lb_target_group.nlb_https[0].arn
  target_id            = module.internal_alb.lb_arn
  port                 = 443
}

resource "aws_lb_target_group" "nlb_http" {
  count                = var.create_nlb ? 1 : 0
  name                 = "tg-${var.application}-nlb-http-1"
  vpc_id               = data.aws_vpc.vpc.id
  port                 = 80
  protocol             = "TCP"
  target_type          = "alb"
  deregistration_delay = 60
  preserve_client_ip   = true

  health_check {
    enabled             = true
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2
    protocol            = "HTTP"
  }
}

resource "aws_lb_target_group_attachment" "alb_to_nlb_http" {
  count                = var.create_nlb ? 1 : 0
  target_group_arn     = aws_lb_target_group.nlb_http[0].arn
  target_id            = module.internal_alb.lb_arn
  port                 = 80
}

resource "aws_lb_listener" "nlb_https" {
  count             = var.create_nlb ? 1 : 0
  load_balancer_arn = aws_lb.nlb[0].arn
  port              = 443
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nlb_https[0].arn
  }
}

resource "aws_lb_listener" "nlb_http" {
  count             = var.create_nlb ? 1 : 0
  load_balancer_arn = aws_lb.nlb[0].arn
  port              = 80
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nlb_http[0].arn
  }
}
