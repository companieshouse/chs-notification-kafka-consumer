locals {
  tags = merge(var.tags, {
    "Terraform" : "true"
    }
  )
}

resource "aws_dx_gateway_association" "this" {
  count = var.transit_gateway_id != null ? 1 : 0

  dx_gateway_id         = aws_dx_gateway.this.id
  associated_gateway_id = var.transit_gateway_id
  allowed_prefixes      = var.allowed_prefixes
}

resource "aws_dx_gateway" "this" {
  name            = "dgw-${var.name}-001"
  amazon_side_asn = var.amazon_side_asn
}

# Create a transit virtual interface per aws_dx_connection we are passed
resource "aws_dx_transit_virtual_interface" "this" {
  count = length(var.aws_dx_connections)

  name          = format("%s-%s-%02d", "dnic", var.name, count.index)
  dx_gateway_id = aws_dx_gateway.this.id
  connection_id = var.aws_dx_connections[count.index].aws_dx_connection_id
  vlan          = var.aws_dx_connections[count.index].vlan_id
  mtu           = var.dx_transit_vif_mtu

  address_family   = var.address_family
  bgp_asn          = var.aws_dx_connections[count.index].bgp_asn
  bgp_auth_key     = var.aws_dx_connections[count.index].bgp_auth_key
  amazon_address   = var.aws_dx_connections[count.index].amazon_address
  customer_address = var.aws_dx_connections[count.index].customer_address

  tags = local.tags
}

data "aws_ec2_transit_gateway_dx_gateway_attachment" "this" {
  count = var.transit_gateway_id != null ? 1 : 0

  transit_gateway_id = var.transit_gateway_id
  dx_gateway_id      = aws_dx_gateway.this.id
}
