data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

data "azurerm_virtual_network" "vnet" {
  name                = var.virtual_network_name
  resource_group_name = data.azurerm_resource_group.rg.name
}

data "azurerm_subnet" "gateway" {
  name                 = "GatewaySubnet"
  virtual_network_name = var.virtual_network_name
  resource_group_name  = data.azurerm_resource_group.rg.name
}

resource "azurerm_public_ip" "this" {
  count = var.create_gateway ? 1 : 0

  name                = "pip-${var.name}-vpn-00${count.index + 1}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  sku               = var.vpn_public_ip_sku
  allocation_method = "Static"

  tags = var.tags
}

resource "azurerm_public_ip" "this_active_active" {
  count = var.vpn_enable_active_active == true ? 1 : 0

  name                = "pip-${var.name}-vpn-00${count.index + 2}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  sku               = var.vpn_public_ip_sku
  allocation_method = "Static"

  tags = var.tags
}


resource "azurerm_virtual_network_gateway" "this" {
  count = var.create_gateway ? 1 : 0

  name                = "vpn-${var.name}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  type          = "Vpn"
  sku           = var.vpn_sku
  vpn_type      = "RouteBased"
  active_active = var.vpn_enable_active_active

  ip_configuration {
    name                          = "${var.name}-ipconfig-00${count.index + 1}"
    public_ip_address_id          = azurerm_public_ip.this[0].id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = data.azurerm_subnet.gateway.id
  }

  dynamic "ip_configuration" {
    for_each = var.vpn_enable_active_active == true ? [1] : []
    content {
      name                          = "${var.name}-ipconfig-00${count.index + 2}"
      public_ip_address_id          = azurerm_public_ip.this_active_active[0].id
      private_ip_address_allocation = "Dynamic"
      subnet_id                     = data.azurerm_subnet.gateway.id
    }
  }

  enable_bgp = var.vpn_enable_bgp
  dynamic "bgp_settings" {
    for_each = var.vpn_enable_bgp == true ? [1] : []
    content {
      asn             = try(var.vpn_bgp_asn, null)
      peering_address = try(var.vpn_bgp_peering_addresses, null)
      peer_weight     = try(var.vpn_bgp_peer_weight, null)
    }
  }

  dynamic "vpn_client_configuration" {
    for_each = var.enable_client_connections == true ? [1] : []
    content {
      address_space        = try(var.vpn_client_address_space, null)
      vpn_client_protocols = try(var.vpn_client_protocols, null)

      aad_tenant   = try(var.vpn_client_aad_tenant, null)
      aad_audience = try(var.vpn_client_aad_audience, null)
      aad_issuer   = try(var.vpn_client_aad_issuer, null)

      radius_server_address = try(var.vpn_client_radius_server_address, null)
      radius_server_secret  = try(var.vpn_client_radius_server_secret, null)

      dynamic "root_certificate" {
        for_each = var.enable_client_connections == true ? var.root_certificates : []
        content {
          name             = root_certificate.value["name"]
          public_cert_data = root_certificate.value["cert_data"]
        }
      }

      dynamic "revoked_certificate" {
        for_each = var.enable_client_connections == true ? var.revoked_certificate : []
        content {
          name       = revoked_certificate.value["name"]
          thumbprint = revoked_certificate.value["thumbprint"]
        }
      }

    }
  }

  tags = var.tags
}






