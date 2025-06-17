data "aws_availability_zones" "zones" {
  state = "available"
}

data "aws_vpc" "vpc" {
  id = var.vpc_id
}

locals {

  network = flatten([
    for i, n in var.networks : [
      for zone in data.aws_availability_zones.zones.names : {
        name     = n.name != null ? "sub-${n.name}-${substr(zone, -1, 0)}" : tostring(null),
        new_bits = n.new_bits,
        az       = zone,
      }
    ]
  ])

  addrs_by_idx = cidrsubnets(data.aws_vpc.vpc.cidr_block, flatten([local.network[*].new_bits])...)
  addrs_by_name = { for i, n in local.network : n.name => {
    name              = n.name,
    cidr_block        = local.addrs_by_idx[i],
    availability_zone = n.az
  } if n.name != null }
  network_objs = [for i, n in local.network : {
    name              = n.name
    cidr_block        = n.name != null ? local.addrs_by_idx[i] : tostring(null)
    availability_zone = n.az
  }]

}