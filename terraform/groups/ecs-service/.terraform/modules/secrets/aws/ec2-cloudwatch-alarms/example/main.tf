provider "aws" {
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "example" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*-x86_64-gp2"]
  }
}

module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name        = var.name
  description = "Security group for example usage with EC2 instance"
  vpc_id      = data.aws_vpc.default.id

}

resource "aws_instance" "ec2" {

  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t3.micro"
  subnet_id                   = element(data.aws_subnets.example.ids, 0)
  vpc_security_group_ids      = [module.security_group.security_group_id]
  associate_public_ip_address = false

}


module "sns_topic" {
  source  = "terraform-aws-modules/sns/aws"
  version = "~> 2.0"

  name         = "${var.name}-sns-topic"
  display_name = "${var.name}-sns-topic"
}


module "cloudwatch_alarms" {
  source = "../../ec2-cloudwatch-alarms"

  name_prefix                       = var.name
  instance_id                       = aws_instance.ec2.id
  cpuutilization_evaluation_periods = "2"
  cpuutilization_statistics_period  = "60"
  cpuutilization_threshold          = "75" # percentage
  status_evaluation_periods         = "3"
  status_statistics_period          = "60"

  enable_disk_alarms = true
  disk_devices = [{
    instance_device_mount_path = "/"
    instance_device_location   = aws_instance.ec2.root_block_device[0].device_name
    instance_device_fstype     = "xfs"
  }]
  disk_evaluation_periods = "3"
  disk_statistics_period  = "120"
  low_disk_threshold      = "10" # percentage


  enable_memory_alarms       = true
  memory_evaluation_periods  = "3"
  memory_statistics_period   = "120"
  available_memory_threshold = "10" # percentage
  used_memory_threshold      = "80" # percentage
  used_swap_memory_threshold = "50" # percentage

  alarm_actions = [
    module.sns_topic.this_sns_topic_arn
  ]
  ok_actions = [
    module.sns_topic.this_sns_topic_arn
  ]

  depends_on = [
    aws_instance.ec2,
    module.sns_topic
  ]

}