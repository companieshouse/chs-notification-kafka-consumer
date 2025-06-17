module "internal_alb_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.3"

  name        = "sgr-${var.application}-internal-alb-001"
  description = "Security group for the ${var.application} servers"
  vpc_id      = data.aws_vpc.vpc.id

  ingress_cidr_blocks = concat(local.admin_cidrs, local.chs_cidrs, local.application_subnet_cidrs, local.client_cidrs, local.test_cidrs)
  ingress_rules       = ["http-80-tcp", "https-443-tcp"]
  egress_rules        = ["all-all"]
}

module "internal_alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 6.5"

  name                       = "alb-${var.application}-int-01"
  vpc_id                     = data.aws_vpc.vpc.id
  internal                   = true
  load_balancer_type         = "application"
  enable_deletion_protection = var.alb_deletion_protection
  idle_timeout               = var.alb_idle_timeout

  security_groups = [module.internal_alb_security_group.security_group_id]
  subnets         = data.aws_subnets.application.ids

  access_logs = {
    bucket  = local.elb_access_logs_bucket_name
    prefix  = local.elb_access_logs_prefix
    enabled = true
  }

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
      action_type        = "redirect"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    },
  ]

  https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = data.aws_acm_certificate.acm_cert.arn
      default_action = {
        type         = "fixed-response"
        status_code  = "503"
        content_type = "text/plain"
      }
    }
  ]

  https_listener_rules = concat(
    var.create_app_target_group ? [{
      https_listener_index = 0
      priority             = 20

      actions = [
        {
          type               = "forward"
          target_group_index = 0
          weight             = 100
        }
      ]
      conditions = [{ host_headers = [format("%s*.*", var.application_type)] }]

    }] : [],
    [for index in range(var.asg_count) : {
      https_listener_index = 0
      priority             = 10 + index

      actions = [
        {
          type               = "forward"
          target_group_index = var.create_app_target_group ? index + 1 : index
          weight             = 100
        }
      ]

      conditions = [{ host_headers = [format("%s-admin-%d.*", var.application, index)] }]
      }
    ]
  )

  target_groups = concat(
    var.create_app_target_group ? [{
      name                 = format("tg-%s-app", var.application)
      backend_protocol     = "HTTP"
      backend_port         = var.application_port
      target_type          = "instance"
      deregistration_delay = 60
      health_check = {
        enabled             = true
        interval            = 30
        path                = var.application_health_check_path
        port                = var.application_port
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }

      stickiness = {
        enabled = true
        type    = "lb_cookie"
      }

      tags = {
        InstanceTargetGroupTag = var.application
      }
    }] : [],
    [for index in range(var.asg_count) : {
      name                 = format("tg-%s-admin-%02d", var.application, index)
      backend_protocol     = "HTTP"
      backend_port         = var.admin_port
      target_type          = "instance"
      deregistration_delay = 10
      health_check = {
        enabled             = true
        interval            = 30
        path                = var.admin_health_check_path
        port                = var.admin_port
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }
      tags = {
        InstanceTargetGroupTag = format("%s-admin", var.application)
      }
      }
    ]
  )
}

#--------------------------------------------
# Internal ALB CloudWatch Alarms
#--------------------------------------------
module "internal_alb_alarms" {
  source = "git@github.com:companieshouse/terraform-modules//aws/alb-cloudwatch-alarms?ref=tags/1.0.288"

  alb_arn_suffix            = module.internal_alb.lb_arn_suffix
  target_group_arn_suffixes = module.internal_alb.target_group_arn_suffixes

  prefix                    = "${var.aws_account}-${var.application}-"
  response_time_threshold   = "100"
  evaluation_periods        = "3"
  statistic_period          = "60"
  maximum_4xx_threshold     = var.maximum_4xx_threshold
  maximum_5xx_threshold     = var.maximum_5xx_threshold
  unhealthy_hosts_threshold = "0"
  tls_negotiation_threshold = "30"

  actions_alarm = var.enable_sns_topic ? [module.cloudwatch_sns_email[0].sns_topic_arn, module.cloudwatch_sns_ooh[0].sns_topic_arn] : []
  actions_ok    = var.enable_sns_topic ? [module.cloudwatch_sns_email[0].sns_topic_arn, module.cloudwatch_sns_ooh[0].sns_topic_arn] : []

  depends_on = [
    module.cloudwatch_sns_email,
    module.cloudwatch_sns_ooh,
    module.internal_alb
  ]
}
