output "gateway_ip" {
  value = module.expressroute.public_ip
}

output "gateway_ip_id" {
  value = [for ip in module.expressroute.public_ip : ip.id]
}

output "expressroute_gateway" {
  value = module.expressroute.expressroute_gateway
}

output "expressroute_gateway_ipconfig" {
  value = module.expressroute.expressroute_gateway[0].ip_configuration
}


