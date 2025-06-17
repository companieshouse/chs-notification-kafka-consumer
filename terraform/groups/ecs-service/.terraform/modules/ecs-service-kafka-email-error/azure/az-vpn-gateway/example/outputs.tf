output "gateway_ip" {
  value = module.vpn.public_ip
}

output "gateway_ip_id" {
  value = [for ip in module.vpn.public_ip : ip.id]
}

output "secondary_gateway_ip" {
  value = var.enable_active_active == true ? module.vpn.public_ip_active_active : null
}

output "secondary_gateway_ip_id" {
  value = var.enable_active_active == true ? [for ip in module.vpn.public_ip_active_active : ip.id] : null
}

output "vpn_gateway" {
  value = module.vpn.vpn_gateway
}

output "vpn_gateway_ipconfig" {
  value = module.vpn.vpn_gateway[0].ip_configuration
}


