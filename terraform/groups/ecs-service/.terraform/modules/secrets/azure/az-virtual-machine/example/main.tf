provider "azurerm" {
  # Whilst version is optional, we /strongly recommend/ using it to pin the version of the Provider being used
  version = ">= 2.4.0"
  features {}
}

resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.location
}

module "vnet" {
  source  = "Azure/vnet/azurerm"
  version = "2.3.0"

  resource_group_name = azurerm_resource_group.this.name
  vnet_name           = "${azurerm_resource_group.this.name}-vnet"
  address_space       = ["10.10.0.0/16"]
  subnet_prefixes     = ["10.10.1.0/24"]
  subnet_names        = ["terratest"]

  tags = {
    Terratest = "True"
  }

  depends_on = [azurerm_resource_group.this]
}

module "windows_virtual_machine" {
  source = "../../az-virtual-machine"

  resource_group_name               = azurerm_resource_group.this.name
  os_type                           = "Windows"
  computer_name                     = "WindowsTestVM"
  virtual_machine_name              = var.win_vm_name
  virtual_machine_size              = "Standard_DS1_v2"
  subnet_id                         = module.vnet.vnet_subnets[0]
  storage_image_reference_publisher = "MicrosoftWindowsServer"
  storage_image_reference_offer     = "WindowsServer"
  storage_image_reference_sku       = "2019-Datacenter"
  storage_image_reference_version   = "latest"
  os_disk_caching                   = "None"
  os_disk_storage_account_type      = "Standard_LRS"
  os_disk_size_gb                   = "200"
  admin_username                    = "terratest"
  admin_password                    = var.admin_pass
  provision_vm_agent                = false
  allow_extension_operations        = false
  windows_enable_automatic_updates  = true

  additional_disks = {
    disk1 = {
      storage_account_type = "Standard_LRS"
      disk_size_gb         = 10
      lun                  = 1
      caching              = "ReadWrite"
    },
    disk2 = {
      storage_account_type = "Premium_LRS"
      disk_size_gb         = 16
      tier                 = "P15"
      lun                  = 2
      caching              = "ReadWrite"
      zones                = ["1"]
    }
  }

  default_tags = {
    Terratest = "True"
  }

  depends_on = [
    azurerm_resource_group.this,
    module.vnet
  ]
}

module "linux_virtual_machine" {
  source = "../../az-virtual-machine"

  resource_group_name               = azurerm_resource_group.this.name
  os_type                           = "linux"
  virtual_machine_name              = var.lin_vm_name
  virtual_machine_size              = "Standard_DS1_v2"
  storage_image_reference_publisher = "Canonical"
  storage_image_reference_offer     = "UbuntuServer"
  storage_image_reference_sku       = "16.04-LTS"
  storage_image_reference_version   = "latest"
  os_disk_caching                   = "ReadWrite"
  os_disk_storage_account_type      = "StandardSSD_LRS"
  os_disk_write_accelerator_enabled = true
  admin_username                    = "terratest"
  allow_extension_operations        = false

  private_ip_allocation_type = "static"
  private_ip_address         = "10.10.1.10"
  subnet_id                  = module.vnet.vnet_subnets[0]


  admin_ssh_keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDycHjNYJlVTVR8r6f5OnSyfU3Wqr+w/46WsbcrpDZg+t8FFCP816a5hXE1SY/frkBTruEF6LsMxW+2ImadlOayAa0aGsNRDz7nzTodl5VbpemoKfqm1pCCa3AtoJ0oKmWUcMZf8VwCpjw+tETPOeaYtjrD3mAXMX73tStW5nFLwAVLC6zIaUwss+X4Fv9okz87ItyGSc5DW+OII+WbmBOgaPtov8JBNPvJlFGgiQRAOh+xf6QAAz8GokfudgPz6kKYa3ZcS/NckrMVQie7T262Ufs2RoMPfjyoaG/oJisglz76D72/BnhMOzofKVq9xum8cmjYPrzPn88xt1V1nOtD Terratest"
  ]

  default_tags = {
    Terratest = "True"
  }

  depends_on = [
    azurerm_resource_group.this,
    module.vnet
  ]
}

