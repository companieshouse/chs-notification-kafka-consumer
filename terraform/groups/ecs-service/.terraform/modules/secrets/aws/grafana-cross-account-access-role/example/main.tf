provider "aws" {
  region = var.aws_region
}

data "aws_caller_identity" "current" {}


module "grafana_access_role" {
  source = "../../grafana-cross-account-access-role"

  grafana_account = data.aws_caller_identity.current.account_id
}
