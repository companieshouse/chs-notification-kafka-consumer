resource "azurerm_public_ip" "this" {
  name                = "${var.publicip_name_prefix}-001"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_public_ip" "this_additional" {
  count = var.additional_public_ips

  name                = format("${var.publicip_name_prefix}-%03d", count.index + 2)
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
}


resource "azurerm_firewall" "this" {
  name                = var.azfirewall_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_tier            = var.sku
  sku_name            = var.sku_type
  firewall_policy_id  = azurerm_firewall_policy.this.id

  ip_configuration {
    name                 = "${var.ip_configuration_name_prefix}-001"
    subnet_id            = var.subnet_id
    public_ip_address_id = azurerm_public_ip.this.id
  }

  dynamic "ip_configuration" {
    for_each = { for idx, ip in azurerm_public_ip.this_additional : idx => ip }
    content {
      name                 = format("${var.ip_configuration_name_prefix}-%03d", ip_configuration.key + 2)
      public_ip_address_id = azurerm_public_ip.this_additional[ip_configuration.key].id
    }
  }
}

resource "azurerm_firewall_policy" "this" {
  name                     = var.azfirewall_policy_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  sku                      = var.sku
  threat_intelligence_mode = var.threat_intelligence_mode

  dns {
    proxy_enabled = try(var.dns_proxy_enabled, null)
    servers       = try(var.dns_servers, null)
  }

}