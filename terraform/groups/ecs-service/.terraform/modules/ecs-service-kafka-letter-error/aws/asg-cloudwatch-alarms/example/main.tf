provider "aws" {
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "this" {
  vpc_id = data.aws_vpc.default.id
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name = "name"

    values = [
      "amzn-ami-hvm-*-x86_64-gp2",
    ]
  }
}

module "asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 3.0"

  # Autoscaling group
  name = "${var.name}-asg"

  vpc_zone_identifier = data.aws_subnet_ids.this.ids
  min_size            = 0
  max_size            = 1
  desired_capacity    = 1

  image_id          = data.aws_ami.amazon_linux.id
  health_check_type = "EC2"
  instance_type     = "t3.micro"

}

module "sns_topic" {
  source  = "terraform-aws-modules/sns/aws"
  version = "~> 2.0"

  name         = "${var.name}-sns-topic"
  display_name = "${var.name}-sns-topic"
}

module "asg_alarms" {
  source = "../"

  autoscaling_group_name = module.asg.this_autoscaling_group_id
  prefix                 = "${var.name}-alarms"

  in_service_evaluation_periods      = "3"
  in_service_statistic_period        = "60"
  expected_instances_in_service      = module.asg.this_autoscaling_group_desired_capacity
  in_pending_evaluation_periods      = "3"
  in_pending_statistic_period        = "60"
  in_standby_evaluation_periods      = "3"
  in_standby_statistic_period        = "60"
  in_terminating_evaluation_periods  = "3"
  in_terminating_statistic_period    = "60"
  total_instances_evaluation_periods = "3"
  total_instances_statistic_period   = "60"
  total_instances_in_service         = module.asg.this_autoscaling_group_desired_capacity

  actions_alarm = [
    module.sns_topic.this_sns_topic_arn
  ]
  actions_ok = [
    module.sns_topic.this_sns_topic_arn
  ]

  depends_on = [
    module.asg,
    module.sns_topic
  ]
}




