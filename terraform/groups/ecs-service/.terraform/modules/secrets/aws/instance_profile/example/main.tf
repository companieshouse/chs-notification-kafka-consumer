provider "aws" {}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "this" {
  vpc_id = data.aws_vpc.default.id
}

resource "aws_cloudwatch_log_group" "terratest" {
  name = var.name

  tags = {
    Environment = "test"
    Terratest   = "true"
  }
}

data "aws_ami" "terratest" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*-x86_64-gp2"]
  }
}

#tfsec:ignore:AWS014
resource "aws_launch_configuration" "terratest" {
  name          = var.name
  image_id      = data.aws_ami.terratest.id
  instance_type = "t2.micro"
}

resource "aws_autoscaling_group" "terratest" {
  desired_capacity     = 1
  max_size             = 1
  min_size             = 1
  force_delete         = true
  launch_configuration = aws_launch_configuration.terratest.name
  vpc_zone_identifier  = data.aws_subnet_ids.this.ids

  tag {
    key                 = "Terratest"
    value               = "true"
    propagate_at_launch = true
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

#tfsec:ignore:AWS002 #tfsec:ignore:AWS017
resource "aws_s3_bucket" "terratest" {
  bucket = replace(lower(var.name), "/[^a-z0-9+]+/", "")
  acl    = "private"

  tags = {
    Environment = "test"
    Terratest   = "true"
  }
}

module "instance_policy" {
  source = "../../instance_profile"

  name              = var.name
  enable_SSM        = true
  SSM_kms_key       = "alias/${var.name}"
  cw_log_group_arns = [aws_cloudwatch_log_group.terratest.arn]
  instance_asg_arns = [aws_autoscaling_group.terratest.arn]
  kms_key_refs = [
    aws_kms_key.terratest.key_id,
    aws_kms_alias.terratest.arn,
  ]
  s3_buckets_read   = [aws_s3_bucket.terratest.arn]
  s3_buckets_write  = [aws_s3_bucket.terratest.arn]
  s3_buckets_delete = [aws_s3_bucket.terratest.arn]
  custom_statements = [
    {
      sid       = "testS3statement"
      effect    = "Allow"
      resources = [aws_s3_bucket.terratest.arn]
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
