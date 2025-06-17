provider "aws" {
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

resource "aws_iam_role" "kmsrole" {
  name               = "kms_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

module "kms" {
  source                  = "../../kms"
  kms_key_alias           = var.name
  description             = "${var.name} testing key"
  deletion_window_in_days = 7 #Set to minumum possible for tests
  enable_key_rotation     = false
  is_enabled              = true

  tags = {
    Environment = "Test"
  }

  kmsadmin_principals            = null
  kmsuser_principals             = [format("role/%s", aws_iam_role.kmsrole.name)]
  key_usage_foreign_account_ids  = [data.aws_caller_identity.current.account_id]
  key_grant_foreign_account_ids  = null
  service_linked_role_principals = ["autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"]
  cloudtrail_account_ids         = [data.aws_caller_identity.current.account_id]
}
