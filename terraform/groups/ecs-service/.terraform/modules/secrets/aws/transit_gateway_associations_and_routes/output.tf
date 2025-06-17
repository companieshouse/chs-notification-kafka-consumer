// aws_ec2_transit_gateway_route
output "this_ec2_transit_gateway_route_ids" {
  description = "List of EC2 Transit Gateway Route Table identifier combined with destination"
  value       = [for route in aws_ec2_transit_gateway_route.this : route.id]
}

output "this_ec2_transit_gateway_route_table_associations" {
  description = "Identifier of the default propagation route table"
  value       = [for association in aws_ec2_transit_gateway_route_table_association.this : association]
}

output "this_ec2_transit_gateway_route_table_attach_propagations" {
  description = "Identifier of the default propagation route table"
  value       = [for propagation in aws_ec2_transit_gateway_route_table_propagation.this_attach : propagation]
}

output "this_ec2_transit_gateway_route_table_propagate_propagations" {
  description = "Identifier of the default propagation route table"
  value       = [for propagation in aws_ec2_transit_gateway_route_table_propagation.this_propagate : propagation]
}