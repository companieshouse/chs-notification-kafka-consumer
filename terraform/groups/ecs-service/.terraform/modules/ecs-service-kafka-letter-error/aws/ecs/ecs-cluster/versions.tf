terraform {
  required_version = "> 1.3.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.54.0"
    }
    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = ">= 2.3.3"
    }
    vault = {
      source  = "hashicorp/vault"
      version = ">= 3.18.0"
    }
  }
}
