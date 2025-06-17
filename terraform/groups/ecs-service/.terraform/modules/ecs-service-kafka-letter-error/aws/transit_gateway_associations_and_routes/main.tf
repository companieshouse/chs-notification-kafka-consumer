#########
# Routes
#########
resource "aws_ec2_transit_gateway_route" "this" {
  for_each = { for route in var.tgw_routes_to_create : route.destination_cidr_block => route }

  destination_cidr_block = each.value.destination_cidr_block
  blackhole              = lookup(each.value, "blackhole", null)

  transit_gateway_route_table_id = each.value.route_table
  transit_gateway_attachment_id  = lookup(each.value, "tgw_attachment_id", null)
}


####################################
# Attachment and Propagation
####################################
resource "aws_ec2_transit_gateway_route_table_association" "this" {
  for_each = { for attach in var.tgw_route_table_association : attach.tgw_attachment_id => attach.route_table }

  transit_gateway_attachment_id  = each.key
  transit_gateway_route_table_id = each.value
}

resource "aws_ec2_transit_gateway_route_table_propagation" "this_attach" {
  for_each = { for attach in var.tgw_route_table_association : attach.tgw_attachment_id => attach.route_table if attach.propagate_vpc_cidr == true }

  transit_gateway_attachment_id  = each.key
  transit_gateway_route_table_id = each.value
}

####################################
# Non associated route table propagation
####################################
resource "aws_ec2_transit_gateway_route_table_propagation" "this_propagate" {
  for_each = { for propagate in var.tgw_route_table_propagate : propagate.tgw_attachment_id => propagate.route_table }

  transit_gateway_attachment_id  = each.key
  transit_gateway_route_table_id = each.value
}