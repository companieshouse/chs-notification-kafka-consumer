# file used by Terraform-Docs only
terraform {
  required_version = ">= 0.12.0, < 0.14"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.4.0"
    }
  }
}
