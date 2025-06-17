provider "aws" {}

data "aws_caller_identity" "current" {}

data "aws_availability_zones" "current" {
  state = "available"
}

data "aws_region" "current" {}

locals {
  bucket_name = replace(lower(var.name), "/[^a-z0-9+]+/", "")

  # Get a zone for private, public and intra, sub divide each per AZ
  subnet_cidrs = [for cidr_block in cidrsubnets(var.vpc_cidr_block, 8, 8, 8) : cidrsubnets(cidr_block, [for az in data.aws_availability_zones.current.names : 3]...)]
}

resource "aws_cloudwatch_log_group" "test" {
  name = var.name

  tags = {
    Environment = "test"
    Terratest   = "true"
  }
}

#tfsec:ignore:AWS002 #tfsec:ignore:AWS017 #tfsec:ignore:AWS077
resource "aws_s3_bucket" "test" {
  bucket = local.bucket_name

  tags = {
    Environment = "test"
    Terratest   = "true"
  }
}

resource "aws_s3_bucket_acl" "example_bucket_acl" {
  bucket = aws_s3_bucket.test.id
  acl    = "private"
}

resource "aws_s3_bucket_policy" "test" {
  bucket = aws_s3_bucket.test.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSLogDeliveryWrite",
            "Effect": "Allow",
            "Principal": {"Service": "delivery.logs.amazonaws.com"},
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::${local.bucket_name}/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
            "Condition": {"StringEquals": {"s3:x-amz-acl": "bucket-owner-full-control"}}
        },
        {
            "Sid": "AWSLogDeliveryAclCheck",
            "Effect": "Allow",
            "Principal": {"Service": "delivery.logs.amazonaws.com"},
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::${local.bucket_name}"
        }
    ]
}
EOF
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

module "firewall" {
  source = "../."

  name = var.name
  vpc_id = module.vpc.vpc_id
  firewall_endpoint_subnets = module.vpc.private_subnets

  firewall_flow_logs_bucket_name = aws_s3_bucket.test.id
  enable_firewall_cloudwatch_alert_logs = true
  cloudwatch_log_retention_days = 1

  # filewall_stateful_engine_evaluation_order = "STRICT_ORDER"

  stateless_rule_groups = module.firewall_rules.aws_networkfirewall_csv_stateless_rule_groups

  domain_rule_groups = module.firewall_rules.aws_networkfirewall_csv_domain_rule_groups

  managed_rule_group_arns = ["arn:aws:network-firewall:${data.aws_region.current.name}:aws-managed:stateful-rulegroup/BotNetCommandAndControlDomainsActionOrder"]
}

module "firewall_rules" {
  source = "../../network_firewall_rules/"

  csv_stateless_rule_files_directories = ["../../network_firewall_rules/example/rules/stateless/"]
  csv_domain_rule_files_directories = ["../../network_firewall_rules/example/rules/domain/"]

}