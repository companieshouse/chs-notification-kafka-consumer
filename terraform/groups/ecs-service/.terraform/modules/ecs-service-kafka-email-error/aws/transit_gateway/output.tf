// aws_ec2_transit_gateway
output "this_ec2_transit_gateway_arn" {
  description = "EC2 Transit Gateway Amazon Resource Name (ARN)"
  value       = element(concat(aws_ec2_transit_gateway.this.*.arn, [""]), 0)
}

output "this_ec2_transit_gateway_association_default_route_table_id" {
  description = "Identifier of the default association route table"
  value       = element(concat(aws_ec2_transit_gateway.this.*.association_default_route_table_id, [""]), 0)
}

output "this_ec2_transit_gateway_id" {
  description = "EC2 Transit Gateway identifier"
  value       = element(concat(aws_ec2_transit_gateway.this.*.id, [""]), 0)
}

output "this_ec2_transit_gateway_owner_id" {
  description = "Identifier of the AWS account that owns the EC2 Transit Gateway"
  value       = element(concat(aws_ec2_transit_gateway.this.*.owner_id, [""]), 0)
}

output "this_ec2_transit_gateway_propagation_default_route_table_id" {
  description = "Identifier of the default propagation route table"
  value       = element(concat(aws_ec2_transit_gateway.this.*.propagation_default_route_table_id, [""]), 0)
}

output "this_ec2_transit_gateway_route_table_ids" {
  description = "List of EC2 Transit Gateway Route Table identifier combined with destination"
  value       = { for table in aws_ec2_transit_gateway_route_table.this : table.tags.Name => table.id }
}

// aws_ram_resource_share
output "this_ram_resource_share_id" {
  description = "The Amazon Resource Name (ARN) of the resource share"
  value       = element(concat(aws_ram_resource_share.this.*.id, [""]), 0)
}

// aws_ram_principal_association
output "this_ram_principal_association_id" {
  description = "The Amazon Resource Name (ARN) of the Resource Share and the principal, separated by a comma"
  value       = element(concat(aws_ram_principal_association.this.*.id, [""]), 0)
}
