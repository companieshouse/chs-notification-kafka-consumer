# file used by Terraform-Docs only
terraform {
  required_version = ">= 0.13.0, < 0.14"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 0.3, < 4.0"
    }
    netapp-cloudmanager = {
      source  = "NetApp/netapp-cloudmanager"
      version = ">= 20.12"
    }
  }
}