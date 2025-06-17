provider "aws" {
}

locals {
  tags = {
    "Test"      = "true"
    "Terraform" = "true"
  }

  # Get a zone for private, public and intra, sub divide each per AZ
  subnet_cidrs = [for cidr_block in cidrsubnets(var.vpc_cidr_block, 8, 8, 8) : cidrsubnets(cidr_block, [for az in data.aws_availability_zones.current.names : 3]...)]
}

data "aws_region" "current" {}

data "aws_availability_zones" "current" {
  state = "available"
}

data "aws_ami" "squid_ami" {
  most_recent = true
  owners      = ["169942020521"]

  filter {
    name   = "name"
    values = ["squid-*"]
  }
}

#tfsec:ignore:AWS002 #tfsec:ignore:AWS017 #tfsec:ignore:AWS077
resource "aws_s3_bucket" "terratest" {
  bucket = replace(lower(var.name), "/[^a-z0-9+]+/", "")
  acl    = "private"

  tags = {
    Environment = "test"
    Terratest   = "true"
  }
}

#tfsec:ignore:AWS002 #tfsec:ignore:AWS017 #tfsec:ignore:AWS077
resource "aws_s3_bucket" "terratest_extra_permission" {
  bucket = replace(lower(join("-", [var.name, "extra"])), "/[^a-z0-9+]+/", "")
  acl    = "private"

  tags = {
    Environment = "test"
    Terratest   = "true"
  }
}


resource "aws_kms_key" "terratest" {
  description             = "${var.name}-kms"
  enable_key_rotation     = true
  deletion_window_in_days = 10
}

resource "aws_kms_alias" "terratest" {
  name          = "alias/${var.name}"
  target_key_id = aws_kms_key.terratest.key_id
}

module "squid_proxy" {
  source = "../."

  name                     = var.name
  instance_type            = "t3.medium"
  ami_id                   = var.ami_id != null ? var.ami_id : data.aws_ami.squid_ami.id
  key_name                 = var.key_pair_name
  proxy_http_ingress_cidrs = [module.vpc.vpc_cidr_block]
  proxy_mgmt_ingress_cidrs = [module.vpc.vpc_cidr_block]
  vpc_id                   = module.vpc.vpc_id
  private_subnet_ids       = module.vpc.private_subnets
  ingress_route_table_ids  = module.vpc.intra_route_table_ids
  enable_ssm               = true
  ssm_session_kms_key      = "alias/${var.name}"
  ssm_logs_kms_key         = "alias/${var.name}"
  ssm_logs_bucket          = aws_s3_bucket.terratest.arn
  custom_iam_statements = [
    {
      sid    = "TestCustomStatements",
      effect = "Allow",
      resources = [
        aws_s3_bucket.terratest_extra_permission.arn,
        "${aws_s3_bucket.terratest_extra_permission.arn}/*"
      ]
      actions = [
        "s3:Get*",
        "s3:List*"
      ]
    }
  ]

  depends_on = [
    aws_kms_alias.terratest
  ]
}

module "vpc" {
  source = "git@github.com:companieshouse/terraform-modules//aws/terraform-aws-vpc?ref=tags/1.0.29"

  name = var.name

  cidr                    = var.vpc_cidr_block
  azs                     = data.aws_availability_zones.current.names
  map_public_ip_on_launch = false

  intra_subnets   = local.subnet_cidrs[0]
  private_subnets = local.subnet_cidrs[1]
  public_subnets  = local.subnet_cidrs[2]

  enable_nat_gateway       = true
  one_nat_gateway_per_az   = false
  reuse_nat_ips            = false
  single_intra_route_table = false

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_flow_log = false
}
