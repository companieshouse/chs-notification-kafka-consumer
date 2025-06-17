data "aws_caller_identity" "current" {}

data "aws_vpc" "vpc" {
  tags = {
    Name = "vpc-${var.aws_account}"
  }
}

data "aws_subnets" "application" {
  filter {
    name   = "tag:Name"
    values = ["sub-application-*"]
  }
}

data "aws_subnet" "application" {
  for_each = toset(data.aws_subnets.application.ids)
  id       = each.value
}

data "aws_security_group" "nagios_shared" {
  filter {
    name   = "group-name"
    values = ["sgr-nagios-inbound-shared-*"]
  }
}

data "aws_security_group" "ssh_access_groups" {
  for_each = toset(var.ssh_access_security_group_patterns)
  filter {
    name   = "group-name"
    values = [each.key]
  }
}

data "aws_route53_zone" "private_zone" {
  name         = local.internal_fqdn
  private_zone = true
}

data "vault_generic_secret" "account_ids" {
  path = "aws-accounts/account-ids"
}

data "vault_generic_secret" "internal_cidrs" {
  path = "aws-accounts/network/internal_cidr_ranges"
}

data "vault_generic_secret" "chs_cidrs" {
  path = "/aws-accounts/network/${var.aws_account}/chs/application-subnets"
}

data "vault_generic_secret" "client_cidrs" {
  path = "applications/${var.aws_account}-${var.aws_region}/${var.application_type}/client_cidrs"
}

data "vault_generic_secret" "test_cidrs" {
  path = "aws-accounts/network/shared-services/test_cidr_ranges"
}

data "vault_generic_secret" "ec2_data" {
  path = "applications/${var.aws_account}-${var.aws_region}/${var.application_type}/app/ec2"
}

data "vault_generic_secret" "nlb_subnet_mappings" {
  count = var.create_nlb ? 1 : 0

  path = "applications/${var.aws_account}-${var.aws_region}/${var.application}/nlb_subnet_mappings"
}

data "aws_acm_certificate" "acm_cert" {
  domain = var.domain_name
  most_recent = true
}

data "vault_generic_secret" "kms_keys" {
  path = "aws-accounts/${var.aws_account}/kms"
}

data "vault_generic_secret" "security_kms_keys" {
  path = "aws-accounts/security/kms"
}

data "vault_generic_secret" "security_s3_buckets" {
  path = "aws-accounts/security/s3"
}

data "aws_ami" "ami" {
  owners      = [data.vault_generic_secret.account_ids.data["development"]]
  most_recent = var.ami_name == "docker-ami-*" ? true : false

  filter {
    name = "name"
    values = [
      var.ami_name,
    ]
  }

  filter {
    name = "state"
    values = [
      "available",
    ]
  }
}

data "template_file" "userdata" {
  template = file("${path.module}/templates/user_data.tpl")
  vars = {
    ANSIBLE_INPUTS             = jsonencode(local.userdata_ansible_inputs)
    ADDITIONAL_USERDATA_PREFIX = var.additional_userdata_prefix
    ADDITIONAL_USERDATA_SUFFIX = var.additional_userdata_suffix
    DNS_DOMAIN                 = local.internal_fqdn
    DNS_ZONE_ID                = data.aws_route53_zone.private_zone.zone_id
  }

}

data "template_cloudinit_config" "userdata_config" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.userdata.rendered
  }
}
