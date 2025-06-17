terraform {
  required_version = ">= 0.13.0, < 0.14"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 0.3, < 4.0"
    }
    netapp-cloudmanager = {
      source  = "NetApp/netapp-cloudmanager"
      version = "20.12"
    }
  }
}

provider "aws" {}

provider "netapp-cloudmanager" {
  refresh_token = var.cloudmanager_refresh_token
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.57.0"

  name = "netapp"

  cidr = "10.10.0.0/16"

  azs             = ["eu-west-2a"]
  public_subnets  = ["10.10.10.0/24"]
  private_subnets = ["10.10.11.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = false

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_ipv6 = false

  tags = {
    Owner       = "test"
    Environment = "netapp"
  }

  vpc_tags = {
    Name = "vpc-netapp"
  }
}

data "aws_security_groups" "default" {
  filter {
    name   = "vpc-id"
    values = [module.vpc.vpc_id]
  }
}

module "netapp_connector" {
  source = "../../netapp_cloudmanager_connector_aws"

  name                  = var.cloudmanager_name
  vpc_id                = module.vpc.vpc_id
  company_name          = "module-test-co"
  instance_type         = "t3.xlarge"
  key_pair_name         = var.key_pair_name
  subnet_id             = coalesce(module.vpc.private_subnets...)
  set_public_ip         = false
  netapp_account_id     = var.cloudmanager_account_id
  netapp_cvo_accountIds = ["559611553046", "559611553234"]

  ingress_ports = [
    { "protocol" = "tcp", "port" = 22 },
    { "protocol" = "tcp", "port" = 80 },
    { "protocol" = "tcp", "port" = 443 },
  ]

  egress_ports = [
    { "protocol" = "-1", "port" = 0 },
  ]

  ingress_cidr_blocks = [
    "10.10.0.0/16",
  ]

  egress_cidr_blocks = [
    "0.0.0.0/0"
  ]

  tags = {
    Terraform = "true",
  }
}