output "routetable_id" {
  description = "The id of the newly created Route Table"
  value       = azurerm_route_table.this.id
}

output "route_ids" {
  description = "The ids of the newly created Routes"
  value       = [for route in azurerm_route.this : route.id]
}