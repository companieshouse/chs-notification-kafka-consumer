terraform {
  required_providers {
    netapp-cloudmanager = {
      source  = "NetApp/netapp-cloudmanager"
      version = ">= 20.12"
    }
  }
}

provider "netapp-cloudmanager" {
  refresh_token = var.cloudmanager_refresh_token
}

provider "aws" {}

data "aws_region" "current" {}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "this" {
  vpc_id = data.aws_vpc.default.id
}

data "aws_route_table" "this" {
  vpc_id = data.aws_vpc.default.id
}

module "netapp_connector" {
  source = "../../netapp_cloudmanager_connector_aws"

  name              = format("%s%s", var.name, "01")
  vpc_id            = data.aws_vpc.default.id
  company_name      = var.name
  instance_type     = "t3.xlarge"
  subnet_id         = coalesce(data.aws_subnet_ids.this.ids...)
  set_public_ip     = true
  netapp_account_id = null

  netapp_cvo_accountIds = ["123456789012", "210987654321"]

  ingress_ports = [
    { "protocol" = "tcp", "port" = 22 },
    { "protocol" = "tcp", "port" = 80 },
    { "protocol" = "tcp", "port" = 443 },
  ]

  egress_ports = [
    { "protocol" = "-1", "port" = 0 },
  ]

  ingress_cidr_blocks = [
    data.aws_vpc.default.cidr_block,
  ]

  egress_cidr_blocks = [
    "0.0.0.0/0"
  ]

  key_pair_name = var.key_name

  tags = {
    Terraform = "true",
  }
}

module "cvo" {
  source = "../../netapp_cloudmanager_cvo_aws"

  name = format("%s%s", var.name, "02")

  connector_client_id = module.netapp_connector.occm_client_id
  svm_password        = var.svm_password

  vpc_id                     = data.aws_vpc.default.id
  subnet_ids                 = data.aws_subnet_ids.this.ids
  ingress_cidr_blocks        = [data.aws_vpc.default.cidr_block]
  ingress_security_group_ids = [module.netapp_connector.occm_security_group_id]

  mediator_key_pair_name = var.key_name
  cluster_floating_ips   = var.cluster_floating_ips
  route_table_ids        = data.aws_route_table.this[*].route_table_id

  #We need depends_on between netapp modules otherwise the connector IAM role is destroyed before CVO can be destroyed causing permissions errors.
  depends_on = [module.netapp_connector]
}