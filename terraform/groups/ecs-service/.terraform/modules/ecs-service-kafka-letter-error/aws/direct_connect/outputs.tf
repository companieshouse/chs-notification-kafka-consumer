output "dx_gateway_id" {
  value       = aws_dx_gateway.this.id
  description = "ID of the AWS Direct Connect Gateway"
}

output "dx_gateway_association_id" {
  value       = element(concat(aws_dx_gateway_association.this[*].id, [""]), 0)
  description = "The ID of the Direct Connect gateway association resource."
}

output "dx_gateway_associated_gateway_type" {
  value       = element(concat(aws_dx_gateway_association.this[*].associated_gateway_type, [""]), 0)
  description = "The type of the associated gateway: transitGateway or virtualPrivateGateway."
}

output "aws_dx_transit_virtual_interface_ids" {
  value       = aws_dx_transit_virtual_interface.this[*].id
  description = "The ID's of the transit virtual interfaces."
}

output "aws_dx_transit_virtual_interface_arns" {
  value       = aws_dx_transit_virtual_interface.this[*].arn
  description = "The ARN's of the transit virtual interfaces."
}

output "aws_dx_transit_virtual_interface_aws_devices" {
  value       = aws_dx_transit_virtual_interface.this[*].aws_device
  description = "The Direct Connect endpoints on which the virtual interfaces terminate."
}

output "aws_dx_transit_virtual_interface_jumbo_frames" {
  value       = aws_dx_transit_virtual_interface.this[*].jumbo_frame_capable
  description = "Indicates whether jumbo frames (8500 MTU) are supported."
}

output "aws_ec2_transit_gateway_dx_gateway_attachment_id" {
  value       = element(concat(data.aws_ec2_transit_gateway_dx_gateway_attachment.this[*].id, [""]), 0)
  description = "EC2 Transit Gateway Attachment identifier, used for associating TGW route tables."
}
