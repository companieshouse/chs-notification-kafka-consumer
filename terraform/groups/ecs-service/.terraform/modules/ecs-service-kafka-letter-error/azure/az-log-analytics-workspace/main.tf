data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

resource "azurerm_log_analytics_workspace" "this" {
  name                = var.name
  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name
  sku                 = var.sku
  retention_in_days   = var.retention_in_days

  tags = var.tags
}