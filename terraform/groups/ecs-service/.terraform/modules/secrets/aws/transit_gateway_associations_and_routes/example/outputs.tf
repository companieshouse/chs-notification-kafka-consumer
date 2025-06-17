output "this_ec2_transit_gateway_route_ids" {
  description = "List of EC2 Transit Gateway Route Table identifier combined with destination"
  value       = module.transit_gateway_routes.this_ec2_transit_gateway_route_ids
}

output "this_ec2_transit_gateway_route_table_associations" {
  description = "Identifier of the default propagation route table"
  value       = module.transit_gateway_routes.this_ec2_transit_gateway_route_table_associations
}

output "this_ec2_transit_gateway_route_table_propagations" {
  description = "Identifier of the default propagation route table"
  value       = module.transit_gateway_routes.this_ec2_transit_gateway_route_table_propagations
}