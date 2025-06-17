data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

resource "azurerm_application_security_group" "this" {
  count = length(var.asg_list)

  name                = var.asg_list[count.index]
  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name

  tags = var.tags
}