output "public_ip" {
  value = azurerm_public_ip.this
}

output "expressroute_gateway" {
  value = azurerm_virtual_network_gateway.this
}


output "expressroute_circuit" {
  value = azurerm_express_route_circuit.this
}


output "expressroute_circuit_connection_auth" {
  value = azurerm_express_route_circuit_authorization.this
}


output "expressroute_gateway_connection" {
  value = azurerm_virtual_network_gateway_connection.this
}