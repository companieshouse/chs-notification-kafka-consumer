output "subnet_ids" {
  value       = [for subnet in aws_subnet.main : subnet.id]
  description = "A list of subnet Ids created using this module"
}

output "named_subnet_ids" {
  description = "Map of subnet names to subnet IDs"

  value = zipmap(
    [for subnet in local.addrs_by_name : subnet.name],
    [for subnet in aws_subnet.main : subnet.id]
  )
}

output "networks" {
  value = [for net in local.network_objs : {
    name              = net.name
    cidr_block        = net.cidr_block
    availability_zone = net.availability_zone
    subnet_id         = aws_subnet.main[net.name].id
    }
  ]
  description = "A list of objects corresponding to each of the objects in the local 'network_objs', each extended with a new attribute 'subnet_id' to make this global usable for subnet details"
}

output "network_cidr_blocks" {
  value       = tomap(local.addrs_by_name)
  description = "A map from network names to allocated address prefixes in CIDR notation."
}


    