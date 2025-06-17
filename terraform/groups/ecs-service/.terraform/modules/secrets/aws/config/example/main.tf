provider "aws" {
  region = var.provider_1_region
}

provider "aws" {
  alias  = "aws2"
  region = var.provider_2_region
}


# Enable config recorder in region 1, with aggregation across other regions
module "config_aggregator" {
  source = "../."

  name = "${var.name}1"

  config_s3_bucket_name                         = aws_s3_bucket.example.id
  config_s3_bucket_prefix                       = var.provider_1_region
  config_recorder_all_supported                 = true
  config_recorder_include_global_resource_types = false

  is_aggregator                       = true
  is_recorder                         = true
  config_aggregate_enable_all_regions = true
  # config_aggregate_regions            = [var.provider_1_region, var.provider_2_region]
  config_aggregate_account_ids = [data.aws_caller_identity.current.account_id]
}

# Enable config recorder in region 2 with a test rule, giving permission to be aggregated by the previous region
module "config" {
  providers = {
    aws = aws.aws2
  }

  source = "../."

  name = "${var.name}2"

  config_s3_bucket_name         = aws_s3_bucket.example.id
  config_s3_bucket_prefix       = var.provider_2_region
  config_recorder_all_supported = true

  is_aggregator                                 = false
  is_recorder                                   = true
  config_recorder_include_global_resource_types = true
  aggregator_account_id                         = data.aws_caller_identity.current.account_id

  config_rules = {
    ACCESS_KEYS_ROTATED = {
      owner             = "AWS",
      source_identifier = "ACCESS_KEYS_ROTATED",
      input_parameters = {
        maxAccessKeyAge = "90"
      }
    },
  }

  depends_on = [
    module.config_aggregator
  ]
}

#tfsec:ignore:AWS002 #tfsec:ignore:AWS017
resource "aws_s3_bucket" "example" {
  bucket = replace(lower(var.name), "/[^a-z0-9+]+/", "")
  acl    = "private"

  tags = {
    Environment = "test"
    Terratest   = "true"
  }
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}
