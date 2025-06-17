# az-virtual-machine

## Create a Linux/Windows Virtual Machine, 
This module can be used to create a Linux or Windows Virtual Machine in Azure, it also creates the NIC for the VM and can be used to create additional data disks if required.

## Usage

```hcl

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
      tier                 = "P15" # only allowed because the storage account type is Premium
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


```


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.0, < 0.14 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 2.4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 2.4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_linux_virtual_machine.this_linux](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine) | resource |
| [azurerm_managed_disk.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/managed_disk) | resource |
| [azurerm_network_interface.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_virtual_machine_data_disk_attachment.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_data_disk_attachment) | resource |
| [azurerm_windows_virtual_machine.this_windows](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_virtual_machine) | resource |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_disks"></a> [additional\_disks](#input\_additional\_disks) | A Map of disk to create and attach to the VM created | `map` | `{}` | no |
| <a name="input_admin_password"></a> [admin\_password](#input\_admin\_password) | (Optional for Linux, Required for Windows) The Password which should be used for the local-administrator on this Virtual Machine. Changing this forces a new resource to be created. The password must be between 6-72 characters long and must satisfy at least 3 of password complexity requirements from the following: [ Contains an uppercase character, Contains a lowercase character, Contains a numeric digit, Contains a special character (Control characters are not allowed)] | `string` | `null` | no |
| <a name="input_admin_ssh_keys"></a> [admin\_ssh\_keys](#input\_admin\_ssh\_keys) | A List of SSH public keys to add to the admin user account. This field is required if disable\_password\_authentication is set to true ( https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine#ssh_keys ). Path has been hardcoded to use the os\_profile\_username as the username. | `list(string)` | `null` | no |
| <a name="input_admin_username"></a> [admin\_username](#input\_admin\_username) | (Required) Specifies the name of the local administrator account. | `string` | n/a | yes |
| <a name="input_allow_extension_operations"></a> [allow\_extension\_operations](#input\_allow\_extension\_operations) | (Optional) Should the Azure Virtual Machine Guest Agent be installed on this Virtual Machine? Defaults to true. When set to true provision\_vm\_agent must also be true | `bool` | `true` | no |
| <a name="input_availability_set_id"></a> [availability\_set\_id](#input\_availability\_set\_id) | (Optional) The ID of the Availability Set in which the Virtual Machine should exist. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_availability_zone"></a> [availability\_zone](#input\_availability\_zone) | Optional) Should Extension Operations be allowed on this Virtual Machine? Defaults to true | `number` | `null` | no |
| <a name="input_boot_diagnostics_storage_account_uri"></a> [boot\_diagnostics\_storage\_account\_uri](#input\_boot\_diagnostics\_storage\_account\_uri) | (Optional) The Primary/Secondary Endpoint for the Azure Storage Account which should be used to store Boot Diagnostics, including Console Output and Screenshots from the Hypervisor. Defaults to a null value which will utilize a Managed Storage Account to store Boot Diagnostics. | `string` | `null` | no |
| <a name="input_computer_name"></a> [computer\_name](#input\_computer\_name) | (Optional) Specifies the Hostname which should be used for this Virtual Machine. If unspecified this defaults to the value for the virtual\_machine\_name field. If the value of the virtual\_machine\_name field is not a valid computer\_name, then you must specify computer\_name. Changing this forces a new resource to be created. If os\_type is Windows then this must be no more than 15 characters in length due to Windows OS limitations | `string` | `null` | no |
| <a name="input_custom_data"></a> [custom\_data](#input\_custom\_data) | (Optional) The Base64-Encoded Custom Data which should be used for this Virtual Machine. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags) | The tags to be applied to this resource | `map(any)` | `{}` | no |
| <a name="input_dns_servers"></a> [dns\_servers](#input\_dns\_servers) | (Optional) A list of IP Addresses defining the DNS Servers which should be used for this Network Interface. | `list(string)` | `null` | no |
| <a name="input_enable_accelerated_networking"></a> [enable\_accelerated\_networking](#input\_enable\_accelerated\_networking) | (Optional) Should Accelerated Networking be enabled? Defaults to false. | `bool` | `false` | no |
| <a name="input_enable_boot_diagnostics"></a> [enable\_boot\_diagnostics](#input\_enable\_boot\_diagnostics) | (Optional) Enable boot diagnostics for the Virtual Machine. | `bool` | `false` | no |
| <a name="input_enable_ip_forwarding"></a> [enable\_ip\_forwarding](#input\_enable\_ip\_forwarding) | (Optional) Should IP Forwarding be enabled? Defaults to false. | `bool` | `false` | no |
| <a name="input_os_disk_caching"></a> [os\_disk\_caching](#input\_os\_disk\_caching) | (Required) The Type of Caching which should be used for the Internal OS Disk. Possible values are None, ReadOnly and ReadWrite. | `string` | n/a | yes |
| <a name="input_os_disk_size_gb"></a> [os\_disk\_size\_gb](#input\_os\_disk\_size\_gb) | (Optional) The Size of the Internal OS Disk in GB, if you wish to vary from the size used in the image this Virtual Machine is sourced from. (typically a minimum of 127GB is required) | `number` | `null` | no |
| <a name="input_os_disk_storage_account_type"></a> [os\_disk\_storage\_account\_type](#input\_os\_disk\_storage\_account\_type) | (Required) The Type of Storage Account which should back this the Internal OS Disk. Possible values are Standard\_LRS, StandardSSD\_LRS and Premium\_LRS. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_os_disk_write_accelerator_enabled"></a> [os\_disk\_write\_accelerator\_enabled](#input\_os\_disk\_write\_accelerator\_enabled) | (Optional) Should Write Accelerator be Enabled for this OS Disk? Defaults to false. | `bool` | `false` | no |
| <a name="input_os_type"></a> [os\_type](#input\_os\_type) | (Required) Specifies the Operating System on the OS Disk. Possible values are linux and windows. | `string` | n/a | yes |
| <a name="input_private_ip_address"></a> [private\_ip\_address](#input\_private\_ip\_address) | (Optional) The Static IP Address which should be used when private\_ip\_allocation\_type is set to static | `string` | `null` | no |
| <a name="input_private_ip_address_version"></a> [private\_ip\_address\_version](#input\_private\_ip\_address\_version) | (Optional) The IP Version to use. Possible values are IPv4 or IPv6. Defaults to IPv4. | `string` | `"IPv4"` | no |
| <a name="input_private_ip_allocation_type"></a> [private\_ip\_allocation\_type](#input\_private\_ip\_allocation\_type) | (Required) The allocation method used for the Private IP Address. Possible values are Dynamic and Static. Defaults to Dynamic. | `string` | `"Dynamic"` | no |
| <a name="input_provision_vm_agent"></a> [provision\_vm\_agent](#input\_provision\_vm\_agent) | (Optional) Should the Azure Virtual Machine Guest Agent be installed on this Virtual Machine? Defaults to true. | `bool` | `true` | no |
| <a name="input_public_ip_address_id"></a> [public\_ip\_address\_id](#input\_public\_ip\_address\_id) | (Optional) Reference to a Public IP Address to associate with this NIC, note that Dynamic IPs may not output fully when referencing the vm resource itself | `string` | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The resource group name this virtual network will be created in | `string` | n/a | yes |
| <a name="input_source_image_id"></a> [source\_image\_id](#input\_source\_image\_id) | (Optional) Specifies the ID of a Custom Image which the Virtual Machine should be created from. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_storage_image_reference_offer"></a> [storage\_image\_reference\_offer](#input\_storage\_image\_reference\_offer) | (Required) Specifies the offer of the image used to create the virtual machine. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_storage_image_reference_publisher"></a> [storage\_image\_reference\_publisher](#input\_storage\_image\_reference\_publisher) | (Required) Specifies the publisher of the image. | `string` | `null` | no |
| <a name="input_storage_image_reference_sku"></a> [storage\_image\_reference\_sku](#input\_storage\_image\_reference\_sku) | (Required) Specifies the SKU of the image used to create the virtual machine. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_storage_image_reference_version"></a> [storage\_image\_reference\_version](#input\_storage\_image\_reference\_version) | (Required) Specifies the version of the image used to create the virtual machine. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | (Optional) The ID of the Subnet where this Network Interface should be located in. | `string` | `null` | no |
| <a name="input_virtual_machine_name"></a> [virtual\_machine\_name](#input\_virtual\_machine\_name) | The name that the Virtual Machine should be given, will be applied to other components and the VM itself, if os\_type is Windows and computer\_name is not used then this variable must be no more than 15 characters in length due to Windows OS limitations | `string` | `"vm"` | no |
| <a name="input_virtual_machine_size"></a> [virtual\_machine\_size](#input\_virtual\_machine\_size) | (Required) Specifies the size of the Virtual Machine. See also Azure VM Naming Conventions. | `string` | n/a | yes |
| <a name="input_windows_additional_unattend_content"></a> [windows\_additional\_unattend\_content](#input\_windows\_additional\_unattend\_content) | (Optional) One or more additional\_unattend\_content blocks as defined in the link. Changing this forces a new resource to be created. ( https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine#additional_unattend_config ) | `map(string)` | `null` | no |
| <a name="input_windows_config_timezone"></a> [windows\_config\_timezone](#input\_windows\_config\_timezone) | (Optional) Specifies the time zone of the virtual machine, the possible values are defined here (https://jackstromberg.com/2017/01/list-of-time-zones-consumed-by-azure/) | `string` | `"GMT Standard Time"` | no |
| <a name="input_windows_enable_automatic_updates"></a> [windows\_enable\_automatic\_updates](#input\_windows\_enable\_automatic\_updates) | (Optional) Are automatic updates enabled on this Virtual Machine? Defaults to false. | `bool` | `false` | no |
| <a name="input_windows_winrm_listener"></a> [windows\_winrm\_listener](#input\_windows\_winrm\_listener) | (Optional) One or more winrm block ( https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine#winrm ) | `map(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_azurerm_network_interface"></a> [azurerm\_network\_interface](#output\_azurerm\_network\_interface) | n/a |
| <a name="output_linux_virtual_machine"></a> [linux\_virtual\_machine](#output\_linux\_virtual\_machine) | Outputs for Linux VM if one is created |
| <a name="output_virtual_machine_data_disks"></a> [virtual\_machine\_data\_disks](#output\_virtual\_machine\_data\_disks) | Outputs any data disks that are created |
| <a name="output_windows_virtual_machine"></a> [windows\_virtual\_machine](#output\_windows\_virtual\_machine) | Outputs for Windows VM if one is created |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Development

### Prerequisites

- [terraform](https://learn.hashicorp.com/terraform/getting-started/install#installing-terraform)
- [terraform-docs](https://github.com/segmentio/terraform-docs)
- [pre-commit](https://pre-commit.com/#install)
- [golang](https://golang.org/doc/install#install)
- [golint](https://github.com/golang/lint#installation)

### Configurations

- Configure pre-commit hooks
```sh
pre-commit install
```


- Configure golang deps for tests
```sh
> go get github.com/gruntwork-io/terratest/modules/terraform
> go get github.com/stretchr/testify/assert
```



### Tests

Tests are available in `test` directory, to make use of the test file you will need to create 2 environment variables for it to "collect":

```sh
  export ARM_SUBSCRIPTION_ID=<your Azure Subscription Id>
```
Once setup you can run the tests as follows:

- In the test directory, run the below command
```sh
go test
```



## Authors

This project is authored by below people

- Martin Fox, Stuart Hunter

> This project was generated by [generator-tf-module](https://github.com/sudokar/generator-tf-module)
