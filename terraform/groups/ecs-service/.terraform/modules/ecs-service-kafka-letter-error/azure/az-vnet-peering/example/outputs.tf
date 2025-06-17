output "vnet_peering_local" {
  value = module.vnet_peer.vnet_peering_local
}

output "vnet_peering_remote" {
  value = module.vnet_peer.vnet_peering_remote
}