provider "azurerm" {
  # Whilst version is optional, we /strongly recommend/ using it to pin the version of the Provider being used
  version = ">= 2.4.0"
  features {}
}

resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.location
}

module "workspace" {
  source              = "../../az-log-analytics-workspace"
  resource_group_name = azurerm_resource_group.this.name

  name              = "${var.resource_group_name}-laworkspace"
  sku               = "Free"
  retention_in_days = "7"


  tags = {
    Terraform   = "True"
    Environment = var.resource_group_name
  }

  depends_on = [azurerm_resource_group.this]
}