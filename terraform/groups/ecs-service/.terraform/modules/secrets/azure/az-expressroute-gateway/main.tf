resource "azurerm_public_ip" "this" {
  count = var.create_gateway ? 1 : 0

  name                = "pip-${var.name}-egw-00${count.index + 1}"
  location            = var.location
  resource_group_name = var.resource_group_name

  sku               = var.expressroute_public_ip_sku
  allocation_method = "Static"

  tags = var.tags
}


resource "azurerm_virtual_network_gateway" "this" {
  count = var.create_gateway ? 1 : 0

  name                = "egw-${var.name}"
  location            = var.location
  resource_group_name = var.resource_group_name

  type = "ExpressRoute"
  sku  = var.expressroute_vpn_sku

  ip_configuration {
    name                          = "${var.name}-expripconfig-00${count.index + 1}"
    public_ip_address_id          = azurerm_public_ip.this[0].id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = var.subnet_id
  }

  tags = var.tags
}

resource "azurerm_express_route_circuit" "this" {
  count = var.create_circuit == true ? 1 : 0

  name                  = "expr-${var.name}-circuit"
  resource_group_name   = var.resource_group_name
  location              = var.location
  service_provider_name = var.circuit_service_provider
  peering_location      = var.circuit_peering_location
  bandwidth_in_mbps     = var.circuit_bandwidth_in_mbps

  sku {
    tier   = var.circuit_sku_tier
    family = var.circuit_sku_family
  }

  tags = var.tags
}

resource "azurerm_express_route_circuit_peering" "example" {
  count = var.create_circuit == true ? 1 : 0

  peering_type                  = "AzurePrivatePeering"
  express_route_circuit_name    = azurerm_express_route_circuit.this[0].name
  resource_group_name           = var.resource_group_name
  peer_asn                      = var.circuit_peer_asn
  primary_peer_address_prefix   = var.circuit_peer_primary_address_prefix
  secondary_peer_address_prefix = var.circuit_peer_secondary_address_prefix
  vlan_id                       = var.circuit_vlanid
  shared_key                    = var.circuit_shared_key

}

resource "azurerm_express_route_circuit_authorization" "this" {
  count = var.create_circuit == true ? 1 : 0

  resource_group_name        = var.resource_group_name
  name                       = "expr-${var.name}-circuit-auth"
  express_route_circuit_name = azurerm_express_route_circuit.this[0].name

}

resource "azurerm_virtual_network_gateway_connection" "this" {
  count = var.create_circuit == true ? 1 : 0

  name                = "expr-${var.name}-connection"
  location            = var.location
  resource_group_name = var.resource_group_name

  type                       = "ExpressRoute"
  express_route_circuit_id   = azurerm_express_route_circuit.this[0].id
  virtual_network_gateway_id = var.create_gateway == true ? azurerm_virtual_network_gateway.this[0].id : var.existing_vgw_id
  enable_bgp                 = var.gateway_connection_enable_bgp
  authorization_key          = azurerm_express_route_circuit_authorization.this[0].authorization_key

  tags = var.tags
}

