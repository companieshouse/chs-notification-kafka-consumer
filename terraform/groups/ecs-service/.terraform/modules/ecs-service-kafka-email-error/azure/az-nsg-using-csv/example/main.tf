provider "azurerm" {
  # Whilst version is optional, we /strongly recommend/ using it to pin the version of the Provider being used
  version = ">= 2.4.0"
  features {}
}

resource "azurerm_resource_group" "main" {
  name     = var.name
  location = var.region
}

module "nsg" {
  source  = "Azure/network-security-group/azurerm"
  version = "3.4.1"

  resource_group_name = azurerm_resource_group.main.name
  security_group_name = "${var.name}-nsg"

  tags = {
    Owner = var.name
  }

  depends_on = [azurerm_resource_group.main]
}

module "nsg_rules" {
  source = "../../nsg_with_csv_rules"

  nsg_resource_group_name = azurerm_resource_group.main.name
  nsg_name                = module.nsg.network_security_group_name
  csv_file_location       = "${path.module}/terratest.csv"

}
