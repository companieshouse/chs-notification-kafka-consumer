provider "aws" {}

locals {

}

module "firewall_rules" {
  source = "../."

  csv_stateless_rule_files_directories = ["rules/stateless/"]
  csv_domain_rule_files_directories = ["rules/domain/"]
}
