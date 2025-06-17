terraform {
  required_version = ">= 0.13, < 0.14"

  required_providers {
    aws = ">= 3.0, < 4.0"
    netapp-cloudmanager = {
      source  = "NetApp/netapp-cloudmanager"
      version = "24.5.0"
    }
  }
}
