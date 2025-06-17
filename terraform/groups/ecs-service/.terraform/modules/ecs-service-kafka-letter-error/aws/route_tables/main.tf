resource "aws_route_table" "main" {
  vpc_id = var.vpcID

  tags = merge(
    {
      "Name" = format("%s", var.name)
    },
    var.tags,
  )

}

resource "aws_route" "main" {

  count          = length(var.route_list)
  route_table_id = aws_route_table.main.id

  destination_cidr_block      = lookup(var.route_list[count.index], "destination_cidr_block", null)
  gateway_id                  = lookup(var.route_list[count.index], "gateway_id", null)
  destination_ipv6_cidr_block = lookup(var.route_list[count.index], "destination_ipv6_cidr_block", null)
  egress_only_gateway_id      = lookup(var.route_list[count.index], "egress_only_gateway_id", null)
  nat_gateway_id              = lookup(var.route_list[count.index], "nat_gateway_id", null)
  local_gateway_id            = lookup(var.route_list[count.index], "local_gateway_id", null)
  network_interface_id        = lookup(var.route_list[count.index], "network_interface_id", null)
  transit_gateway_id          = lookup(var.route_list[count.index], "transit_gateway_id", null)
  vpc_peering_connection_id   = lookup(var.route_list[count.index], "vpc_peering_connection_id", null)

}

resource "aws_route_table_association" "main" {
  count          = length(var.subnet_list)
  subnet_id      = var.subnet_list[count.index]
  route_table_id = aws_route_table.main.id
}
