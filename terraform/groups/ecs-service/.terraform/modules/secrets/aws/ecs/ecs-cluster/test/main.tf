locals {
  # test values hardcoded here
  stack_name  = "ecs-lib"
  environment = "test"
  name_prefix = "${local.stack_name}-${local.environment}"

  aws_region                 = "eu-west-2"
  asg_max_instance_count     = 1
  asg_min_instance_count     = 1
  asg_desired_instance_count = 1
  scaledown_schedule         = "00 20 * * 1-7"
  scaleup_schedule           = "00 06 * * 1-7"
  ec2_instance_type          = "t3.micro"
  ec2_key_pair_name          = ""                      #"stack-pocs"
  ec2_image_id               = "ami-0f49b2a9014635082" # ECS optimized Amazon Linux in London created 10/07/2019
  ec2_ingress_cidr_blocks    = "0.0.0.0/0"
}

provider "aws" {
  region  = local.aws_region
}

terraform {
  required_version = "> 1.3.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.54.0"
    }
    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = ">= 2.3.3"
    }
    vault = {
      source  = "hashicorp/vault"
      version = ">= 3.18.0"
    }
  }
}

# Get default VPC and subnets to keep test simple rather than using networks remote state
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "all" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

module "ecs-cluster" {
  source = "../" # up to root of repo

  # Standard Variables
  stack_name  = local.stack_name
  name_prefix = local.name_prefix
  environment = local.environment

  # Network Variables
  vpc_id     = "${data.aws_vpc.default.id}"
  subnet_ids = "${join(",", data.aws_subnets.all.ids)}"

  # Auto Scaling Group Variables
  asg_max_instance_count     = local.asg_max_instance_count
  asg_min_instance_count     = local.asg_min_instance_count
  asg_desired_instance_count = local.asg_desired_instance_count
  scaledown_schedule         = local.scaledown_schedule
  scaleup_schedule           = local.scaleup_schedule

  # EC2 Launch Configuration Variables
  ec2_key_pair_name       = local.ec2_key_pair_name
  ec2_instance_type       = local.ec2_instance_type
  ec2_image_id            = local.ec2_image_id
  ec2_ingress_cidr_blocks = local.ec2_ingress_cidr_blocks
}
