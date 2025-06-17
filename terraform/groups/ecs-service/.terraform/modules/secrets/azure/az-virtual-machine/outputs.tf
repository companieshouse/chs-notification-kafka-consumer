output "azurerm_network_interface" {
  value = azurerm_network_interface.this
}

output "linux_virtual_machine" {
  value       = concat(azurerm_linux_virtual_machine.this_linux, [null])[0]
  description = "Outputs for Linux VM if one is created"
}

output "windows_virtual_machine" {
  value       = concat(azurerm_windows_virtual_machine.this_windows, [null])[0]
  description = "Outputs for Windows VM if one is created"
}

output "virtual_machine_data_disks" {
  value       = { for disk in azurerm_managed_disk.this : disk.name => disk }
  description = "Outputs any data disks that are created"
}