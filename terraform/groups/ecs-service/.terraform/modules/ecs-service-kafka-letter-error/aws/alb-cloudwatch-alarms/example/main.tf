provider "aws" {
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "this" {
  vpc_id = data.aws_vpc.default.id
}

module "alb" {
  source             = "terraform-aws-modules/alb/aws"
  version            = "~> 5.0"
  name               = "terratest-alb"
  load_balancer_type = "application"
  vpc_id             = data.aws_vpc.default.id
  subnets            = data.aws_subnet_ids.this.ids
  internal           = true

  target_groups = [
    {
      name_prefix      = "pref-"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
    },
    {
      name_prefix      = "pref-"
      backend_protocol = "HTTPS"
      backend_port     = 443
      target_type      = "instance"
    }
  ]
  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]
  tags = {
    Environment = "Test"
  }
}

module "sns_topic" {
  source  = "terraform-aws-modules/sns/aws"
  version = "~> 2.0"

  name         = "terratest-topic"
  display_name = "terratest-topic"
}

module "alb_alarms" {
  source = "../"

  alb_arn_suffix            = module.alb.this_lb_arn_suffix
  target_group_arn_suffixes = module.alb.target_group_arn_suffixes
  prefix                    = "terratestAlarm-"
  response_time_threshold   = "100"
  evaluation_periods        = "3"
  statistic_period          = "60"
  actions_alarm = [
    module.sns_topic.this_sns_topic_arn
  ]
  actions_ok = [
    module.sns_topic.this_sns_topic_arn
  ]
  maximum_4xx_threshold = "1"
  maximum_5xx_threshold = "1"

  depends_on = [
    module.alb,
    module.sns_topic
  ]
}
