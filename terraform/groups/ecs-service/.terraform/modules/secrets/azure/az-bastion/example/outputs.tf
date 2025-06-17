output "bastion" {
  value = module.bastion.bastion_host
}

output "bastion_public_ip" {
  value = module.bastion.bastion_public_ip
}

output "bastion_network_security_group" {
  value = module.bastion.bastion_network_security_group
}
