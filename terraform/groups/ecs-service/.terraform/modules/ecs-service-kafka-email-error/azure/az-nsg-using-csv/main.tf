locals {
  security_group_rules = csvdecode(file(var.csv_file_location))
}

resource "azurerm_network_security_rule" "inbound_rules" {
  for_each = { for rule in local.security_group_rules : rule.priority => rule if upper(rule.direction) == "INBOUND" }

  resource_group_name         = var.nsg_resource_group_name
  network_security_group_name = var.nsg_name

  priority    = each.key
  name        = length(each.value.name) < 1 ? null : each.value.name
  description = length(each.value.description) < 1 ? null : each.value.description
  direction   = length(each.value.direction) < 1 ? null : each.value.direction
  access      = length(each.value.access) < 1 ? null : each.value.access
  protocol    = length(each.value.protocol) < 1 ? null : each.value.protocol
  # Source
  source_address_prefix   = can(regex("; ", each.value.source)) == false ? each.value.source : null
  source_address_prefixes = can(regex("; ", each.value.source)) ? formatlist("%s", split("; ", each.value.source)) : null
  source_port_range       = can(regex("; ", each.value.sourceports)) == false ? each.value.sourceports : null
  source_port_ranges      = can(regex("; ", each.value.sourceports)) ? formatlist("%s", split("; ", each.value.sourceports)) : null
  # Destination
  destination_address_prefix   = can(regex("; ", each.value.destination)) == false ? each.value.destination : null
  destination_address_prefixes = can(regex("; ", each.value.destination)) ? formatlist("%s", split("; ", each.value.destination)) : null
  destination_port_range       = can(regex("; ", each.value.destinationports)) == false ? each.value.destinationports : null
  destination_port_ranges      = can(regex("; ", each.value.destinationports)) ? formatlist("%s", split("; ", each.value.destinationports)) : null

}

resource "azurerm_network_security_rule" "outbound_rules" {
  for_each = { for rule in local.security_group_rules : rule.priority => rule if upper(rule.direction) == "OUTBOUND" }

  resource_group_name         = var.nsg_resource_group_name
  network_security_group_name = var.nsg_name
  priority                    = each.key
  name                        = length(each.value.name) < 1 ? null : each.value.name
  description                 = length(each.value.description) < 1 ? null : each.value.description
  direction                   = length(each.value.direction) < 1 ? null : each.value.direction
  access                      = length(each.value.access) < 1 ? null : each.value.access
  protocol                    = length(each.value.protocol) < 1 ? null : each.value.protocol
  # Source
  source_address_prefix   = can(regex("; ", each.value.source)) == false ? each.value.source : null
  source_address_prefixes = can(regex("; ", each.value.source)) ? formatlist("%s", split("; ", each.value.source)) : null
  source_port_range       = can(regex("; ", each.value.sourceports)) == false ? each.value.sourceports : null
  source_port_ranges      = can(regex("; ", each.value.sourceports)) ? formatlist("%s", split("; ", each.value.sourceports)) : null
  # Destination
  destination_address_prefix   = can(regex("; ", each.value.destination)) == false ? each.value.destination : null
  destination_address_prefixes = can(regex("; ", each.value.destination)) ? formatlist("%s", split("; ", each.value.destination)) : null
  destination_port_range       = can(regex("; ", each.value.destinationports)) == false ? each.value.destinationports : null
  destination_port_ranges      = can(regex("; ", each.value.destinationports)) ? formatlist("%s", split("; ", each.value.destinationports)) : null

}
