provider "azurerm" {
  # Whilst version is optional, we /strongly recommend/ using it to pin the version of the Provider being used
  version = ">= 2.4.0"
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location
}

module "asg" {
  source              = "../../az-application-security-group"
  resource_group_name = azurerm_resource_group.example.name

  asg_list = [
    "asg1",
    "asg2"
  ]

  tags = {
    environment = "test"
  }

  depends_on = [azurerm_resource_group.example]
}
