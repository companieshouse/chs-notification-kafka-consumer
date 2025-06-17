terraform {
  required_version = ">= 0.12.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 2.41"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 3.0"
    }
  }
}
