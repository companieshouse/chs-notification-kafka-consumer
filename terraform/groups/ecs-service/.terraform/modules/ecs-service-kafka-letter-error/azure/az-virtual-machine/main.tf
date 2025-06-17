data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

resource "azurerm_network_interface" "this" {
  name                = "${var.virtual_machine_name}-nic"
  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name

  dns_servers                   = var.dns_servers
  enable_ip_forwarding          = var.enable_ip_forwarding
  enable_accelerated_networking = var.enable_accelerated_networking

  ip_configuration {
    name                          = "${var.virtual_machine_name}-nic"
    private_ip_address_allocation = var.private_ip_allocation_type
    private_ip_address_version    = var.private_ip_address_version
    subnet_id                     = var.subnet_id
    private_ip_address            = lower(var.private_ip_allocation_type) == "static" ? var.private_ip_address : null
    public_ip_address_id          = try(var.public_ip_address_id, null)
  }

  tags = var.default_tags
}

resource "azurerm_linux_virtual_machine" "this_linux" {
  count = lower(var.os_type) == "linux" ? 1 : 0

  name                       = var.virtual_machine_name
  computer_name              = try(var.computer_name, var.virtual_machine_name)
  resource_group_name        = data.azurerm_resource_group.this.name
  location                   = data.azurerm_resource_group.this.location
  network_interface_ids      = [azurerm_network_interface.this.id]
  availability_set_id        = var.availability_set_id
  provision_vm_agent         = try(var.provision_vm_agent, true)
  allow_extension_operations = try(var.allow_extension_operations, true)
  zone                       = var.availability_zone
  size                       = var.virtual_machine_size
  custom_data                = try(var.custom_data, null)

  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = var.admin_password == null ? true : false

  dynamic "admin_ssh_key" {
    iterator = key
    for_each = var.admin_password == null ? toset(var.admin_ssh_keys) : []
    content {
      username   = var.admin_username
      public_key = key.value
    }
  }

  source_image_id = try(var.source_image_id, null)
  source_image_reference {
    publisher = var.source_image_id == null ? var.storage_image_reference_publisher : null
    offer     = var.source_image_id == null ? var.storage_image_reference_offer : null
    sku       = var.source_image_id == null ? var.storage_image_reference_sku : null
    version   = var.source_image_id == null ? var.storage_image_reference_version : null
  }

  os_disk {
    name                      = "${var.virtual_machine_name}-osdisk"
    caching                   = var.os_disk_caching
    storage_account_type      = var.os_disk_storage_account_type
    disk_size_gb              = try(var.os_disk_size_gb, null)
    write_accelerator_enabled = var.os_disk_storage_account_type == "Premium_LRS" && var.os_disk_caching == "None" ? var.os_disk_write_accelerator_enabled : false
  }


  dynamic "boot_diagnostics" {
    for_each = var.enable_boot_diagnostics ? [1] : []
    content {
      storage_account_uri = try(var.boot_diagnostics_storage_account_uri, null)
    }
  }

  tags = var.default_tags
}

resource "azurerm_windows_virtual_machine" "this_windows" {
  count = lower(var.os_type) == "windows" ? 1 : 0

  name                       = var.virtual_machine_name
  computer_name              = try(var.computer_name, var.virtual_machine_name)
  resource_group_name        = data.azurerm_resource_group.this.name
  location                   = data.azurerm_resource_group.this.location
  network_interface_ids      = [azurerm_network_interface.this.id]
  availability_set_id        = try(var.availability_set_id, null)
  provision_vm_agent         = var.provision_vm_agent
  allow_extension_operations = var.allow_extension_operations
  enable_automatic_updates   = try(var.windows_enable_automatic_updates, false)
  timezone                   = try(var.windows_config_timezone, null)
  zone                       = var.availability_zone
  size                       = var.virtual_machine_size
  custom_data                = try(var.custom_data, null)

  admin_username = var.admin_username
  admin_password = var.admin_password

  source_image_id = try(var.source_image_id, null)
  source_image_reference {
    publisher = var.source_image_id == null ? var.storage_image_reference_publisher : null
    offer     = var.source_image_id == null ? var.storage_image_reference_offer : null
    sku       = var.source_image_id == null ? var.storage_image_reference_sku : null
    version   = var.source_image_id == null ? var.storage_image_reference_version : null
  }

  os_disk {
    name                      = "${var.virtual_machine_name}-osdisk"
    caching                   = var.os_disk_caching
    storage_account_type      = var.os_disk_storage_account_type
    disk_size_gb              = try(var.os_disk_size_gb, null)
    write_accelerator_enabled = var.os_disk_storage_account_type == "Premium_LRS" && var.os_disk_caching == "None" ? var.os_disk_write_accelerator_enabled : false
  }

  dynamic "additional_unattend_content" {
    iterator = unattend
    for_each = var.windows_additional_unattend_content != null ? [1] : []
    content {
      content = unattend.value.content
      setting = unattend.value.setting
    }
  }

  dynamic "winrm_listener" {
    iterator = winrm
    for_each = var.windows_winrm_listener != null ? [1] : []
    content {
      protocol        = unattend.value.protocol
      certificate_url = unattend.value.protocol == true ? try(unattend.value.certificate_url, null) : null
    }
  }

  dynamic "boot_diagnostics" {
    for_each = var.enable_boot_diagnostics ? [1] : []
    content {
      storage_account_uri = try(var.boot_diagnostics_storage_account_uri, null)
    }
  }

  lifecycle {
    ignore_changes = ["identity"]
  }

  tags = var.default_tags
}


