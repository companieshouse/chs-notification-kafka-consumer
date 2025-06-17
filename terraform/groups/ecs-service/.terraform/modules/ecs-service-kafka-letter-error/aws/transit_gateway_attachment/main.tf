###########################################################
# VPC Attachments, route table association and propagation
###########################################################
resource "aws_ec2_transit_gateway_vpc_attachment" "this" {
  for_each = var.vpc_attachments

  transit_gateway_id = each.value["tgw_id"]
  vpc_id             = each.value["vpc_id"]
  subnet_ids         = each.value["subnet_ids"]

  dns_support                                     = lookup(each.value, "dns_support", true) ? "enable" : "disable"
  ipv6_support                                    = lookup(each.value, "ipv6_support", false) ? "enable" : "disable"
  transit_gateway_default_route_table_association = lookup(each.value, "transit_gateway_default_route_table_association", true)
  transit_gateway_default_route_table_propagation = lookup(each.value, "transit_gateway_default_route_table_propagation", true)
  appliance_mode_support                          = lookup(each.value, "appliance_mode_support", false) ? "enable" : "disable"

  tags = merge(
    {
      "Name" = var.name
    },
    var.tags,
    lookup(each.value, "tgw_vpc_attachment_tags", null)
  )
}
