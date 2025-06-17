data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

resource "azurerm_route_table" "this" {
  name                          = var.route_table_name
  location                      = data.azurerm_resource_group.this.location
  resource_group_name           = data.azurerm_resource_group.this.name
  disable_bgp_route_propagation = var.disable_bgp_route_propagation

  tags = var.tags
}

resource "azurerm_route" "this" {
  count = length(var.route_list)

  name                = lookup(var.route_list[count.index], "name", "route-${count.index}")
  resource_group_name = data.azurerm_resource_group.this.name
  route_table_name    = azurerm_route_table.this.name

  address_prefix         = lookup(var.route_list[count.index], "route_prefix", null)
  next_hop_type          = lookup(var.route_list[count.index], "route_nexthop_type", null)
  next_hop_in_ip_address = lookup(var.route_list[count.index], "route_nexthop_type", null) == "VirtualAppliance" ? lookup(var.route_list[count.index], "next_hop_in_ip_address", null) : null

}