# file used by Terraform-Docs only
terraform {
  required_version = ">= 0.13.0, < 2.0.0"

  required_providers {
    aws   = ">= 0.3, < 6.0"
    vault = ">= 2.0.0"
  }
}
