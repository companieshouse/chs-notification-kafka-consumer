data "cloudinit_config" "userdata_config" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/ec2-user-data.tmpl", {
      ecs_cluster_name = aws_ecs_cluster.ecs-cluster.name
    })
  }
}

data "aws_ec2_managed_prefix_list" "administration" {
  name = "administration-cidr-ranges"
}

data "aws_subnets" "alb_subnet_ids" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
  filter {
    name   = "tag:Name"
    values = var.alb_subnet_patterns
  }
}

data "aws_subnet" "alb_subnets" {
  for_each = toset(data.aws_subnets.alb_subnet_ids.ids)
  id       = each.value
}

data "aws_caller_identity" "current" {}

data "aws_iam_role" "asg" {
  name = "AWSServiceRoleForAutoScaling"
}

data "vault_generic_secret" "security_kms_keys" {
  count = var.ec2_enable_ssm_logging ? 1 : 0
  path  = "aws-accounts/security/kms"
}

data "vault_generic_secret" "security_s3_buckets" {
  count = var.ec2_enable_ssm_logging ? 1 : 0
  path  = "aws-accounts/security/s3"
}
