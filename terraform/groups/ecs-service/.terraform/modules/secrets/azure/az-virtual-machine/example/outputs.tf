output "windows_vm_nic" {
  value = module.windows_virtual_machine.azurerm_network_interface
}

output "windows_vm" {
  value = module.windows_virtual_machine.windows_virtual_machine
}

output "windows_vm_disks" {
  value = module.windows_virtual_machine.virtual_machine_data_disks
}

output "linux_vm_nic" {
  value = module.linux_virtual_machine.azurerm_network_interface
}

output "linux_vm" {
  value = module.linux_virtual_machine.linux_virtual_machine
}