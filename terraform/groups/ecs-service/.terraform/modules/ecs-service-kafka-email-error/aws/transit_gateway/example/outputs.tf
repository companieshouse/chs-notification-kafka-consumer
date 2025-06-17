// aws_ec2_transit_gateway
output "this_ec2_transit_gateway_arn" {
  description = "EC2 Transit Gateway Amazon Resource Name (ARN)"
  value       = module.transit_gateway.this_ec2_transit_gateway_arn
}

output "this_ec2_transit_gateway_id" {
  description = "EC2 Transit Gateway identifier"
  value       = module.transit_gateway.this_ec2_transit_gateway_id
}

output "this_ec2_transit_gateway_owner_id" {
  description = "Identifier of the AWS account that owns the EC2 Transit Gateway"
  value       = module.transit_gateway.this_ec2_transit_gateway_owner_id
}

output "this_ec2_transit_gateway_association_default_route_table_id" {
  description = "Identifier of the default association route table"
  value       = module.transit_gateway.this_ec2_transit_gateway_association_default_route_table_id
}

output "this_ec2_transit_gateway_propagation_default_route_table_id" {
  description = "Identifier of the default propagation route table"
  value       = module.transit_gateway.this_ec2_transit_gateway_propagation_default_route_table_id
}

output "this_ec2_transit_gateway_route_table_ids" {
  description = "List of EC2 Transit Gateway Route Table identifier combined with destination"
  value       = module.transit_gateway.this_ec2_transit_gateway_route_table_ids
}

// aws_ram_resource_share
output "this_ram_resource_share_id" {
  description = "The Amazon Resource Name (ARN) of the resource share"
  value       = module.transit_gateway.this_ram_resource_share_id
}

// aws_ram_principal_association
output "this_ram_principal_association_id" {
  description = "The Amazon Resource Name (ARN) of the Resource Share and the principal, separated by a comma"
  value       = module.transit_gateway.this_ram_principal_association_id
}
