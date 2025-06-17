resource "azurerm_managed_disk" "this" {
  for_each = var.additional_disks

  name                 = "${var.virtual_machine_name}-${each.key}"
  location             = data.azurerm_resource_group.this.location
  resource_group_name  = data.azurerm_resource_group.this.name
  storage_account_type = each.value.storage_account_type
  create_option        = "Empty"
  tier                 = each.value.storage_account_type == "Premium_LRS" ? lookup(each.value, "tier", null) : null
  disk_size_gb         = each.value.disk_size_gb
  zones                = lookup(each.value, "zones", null)

  tags = var.default_tags
}

resource "azurerm_virtual_machine_data_disk_attachment" "this" {
  for_each = var.additional_disks

  managed_disk_id    = azurerm_managed_disk.this[each.key].id
  virtual_machine_id = lower(var.os_type) == "windows" ? azurerm_windows_virtual_machine.this_windows[0].id : azurerm_linux_virtual_machine.this_linux[0].id
  lun                = each.value.lun
  caching            = each.value.caching

}