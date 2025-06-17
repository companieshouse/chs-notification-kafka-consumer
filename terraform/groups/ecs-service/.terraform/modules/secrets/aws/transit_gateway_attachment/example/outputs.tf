// aws_ec2_transit_gateway_vpc_attachment
output "this_ec2_transit_gateway_vpc_attachment_ids" {
  description = "List of EC2 Transit Gateway VPC Attachment identifiers"
  value       = module.tgw_attachment.this_ec2_transit_gateway_vpc_attachment_ids
}

output "this_ec2_transit_gateway_vpc_attachment" {
  description = "Map of EC2 Transit Gateway VPC Attachment attributes"
  value       = module.tgw_attachment.this_ec2_transit_gateway_vpc_attachment
}