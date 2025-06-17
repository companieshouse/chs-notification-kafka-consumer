provider "azurerm" {
  # Whilst version is optional, we /strongly recommend/ using it to pin the version of the Provider being used
  version = ">= 2.4.0"
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location
}

module "routetable" {
  source              = "../../az-route-table"
  resource_group_name = azurerm_resource_group.example.name

  route_list = [
    {
      route_prefix       = "10.0.1.0/24"
      route_nexthop_type = "None"
    },
    {
      route_prefix       = "10.0.2.0/24"
      route_nexthop_type = "VnetLocal"
    },
    {
      route_prefix           = "10.0.3.0/24"
      route_nexthop_type     = "VirtualAppliance"
      next_hop_in_ip_address = "10.0.2.5"
    },
    {
      route_prefix       = "0.0.0.0/0"
      route_nexthop_type = "Internet"
    }
  ]

  tags = {
    environment = "test"
  }

  depends_on = [azurerm_resource_group.example]
}
