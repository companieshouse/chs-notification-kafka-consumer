variable "resource_group_name" {
  type        = string
  description = "The resource group name this virtual network will be created in"
}

variable "os_type" {
  type        = string
  description = "(Required) Specifies the Operating System on the OS Disk. Possible values are linux and windows."
}

variable "virtual_machine_name" {
  type        = string
  description = "The name that the Virtual Machine should be given, will be applied to other components and the VM itself, if os_type is Windows and computer_name is not used then this variable must be no more than 15 characters in length due to Windows OS limitations"
  default     = "vm"
}

variable "computer_name" {
  type        = string
  description = "(Optional) Specifies the Hostname which should be used for this Virtual Machine. If unspecified this defaults to the value for the virtual_machine_name field. If the value of the virtual_machine_name field is not a valid computer_name, then you must specify computer_name. Changing this forces a new resource to be created. If os_type is Windows then this must be no more than 15 characters in length due to Windows OS limitations"
  default     = null
}

variable "subnet_id" {
  type        = string
  description = "(Optional) The ID of the Subnet where this Network Interface should be located in."
  default     = null
}

variable "private_ip_allocation_type" {
  type        = string
  description = "(Required) The allocation method used for the Private IP Address. Possible values are Dynamic and Static. Defaults to Dynamic."
  default     = "Dynamic"
}

variable "private_ip_address_version" {
  type        = string
  description = "(Optional) The IP Version to use. Possible values are IPv4 or IPv6. Defaults to IPv4."
  default     = "IPv4"
}

variable "public_ip_address_id" {
  type        = string
  description = "(Optional) Reference to a Public IP Address to associate with this NIC, note that Dynamic IPs may not output fully when referencing the vm resource itself"
  default     = null
}

variable "private_ip_address" {
  type        = string
  description = "(Optional) The Static IP Address which should be used when private_ip_allocation_type is set to static"
  default     = null
}

variable "dns_servers" {
  type        = list(string)
  description = "(Optional) A list of IP Addresses defining the DNS Servers which should be used for this Network Interface."
  default     = null
}

variable "enable_ip_forwarding" {
  type        = bool
  description = "(Optional) Should IP Forwarding be enabled? Defaults to false."
  default     = false
}

variable "enable_accelerated_networking" {
  type        = bool
  description = "(Optional) Should Accelerated Networking be enabled? Defaults to false."
  default     = false
}

variable "admin_username" {
  type        = string
  description = "(Required) Specifies the name of the local administrator account."
}

variable "admin_password" {
  type        = string
  description = "(Optional for Linux, Required for Windows) The Password which should be used for the local-administrator on this Virtual Machine. Changing this forces a new resource to be created. The password must be between 6-72 characters long and must satisfy at least 3 of password complexity requirements from the following: [ Contains an uppercase character, Contains a lowercase character, Contains a numeric digit, Contains a special character (Control characters are not allowed)]"
  default     = null
}

variable "virtual_machine_size" {
  type        = string
  description = "(Required) Specifies the size of the Virtual Machine. See also Azure VM Naming Conventions."
}

variable "availability_set_id" {
  type        = string
  description = "(Optional) The ID of the Availability Set in which the Virtual Machine should exist. Changing this forces a new resource to be created."
  default     = null
}

variable "provision_vm_agent" {
  type        = bool
  description = "(Optional) Should the Azure Virtual Machine Guest Agent be installed on this Virtual Machine? Defaults to true."
  default     = true
}

variable "allow_extension_operations" {
  type        = bool
  description = "(Optional) Should the Azure Virtual Machine Guest Agent be installed on this Virtual Machine? Defaults to true. When set to true provision_vm_agent must also be true"
  default     = true
}

variable "availability_zone" {
  type        = number
  description = "Optional) Should Extension Operations be allowed on this Virtual Machine? Defaults to true"
  default     = null
}


variable "source_image_id" {
  type        = string
  description = "(Optional) Specifies the ID of a Custom Image which the Virtual Machine should be created from. Changing this forces a new resource to be created."
  default     = null
}

variable "storage_image_reference_publisher" {
  type        = string
  description = "(Required) Specifies the publisher of the image."
  default     = null
}

variable "storage_image_reference_offer" {
  type        = string
  description = "(Required) Specifies the offer of the image used to create the virtual machine. Changing this forces a new resource to be created."
  default     = null
}

variable "storage_image_reference_sku" {
  type        = string
  description = "(Required) Specifies the SKU of the image used to create the virtual machine. Changing this forces a new resource to be created."
  default     = null
}

variable "storage_image_reference_version" {
  type        = string
  description = "(Required) Specifies the version of the image used to create the virtual machine. Changing this forces a new resource to be created."
  default     = null
}

variable "os_disk_caching" {
  type        = string
  description = "(Required) The Type of Caching which should be used for the Internal OS Disk. Possible values are None, ReadOnly and ReadWrite."
}

variable "os_disk_storage_account_type" {
  type        = string
  description = "(Required) The Type of Storage Account which should back this the Internal OS Disk. Possible values are Standard_LRS, StandardSSD_LRS and Premium_LRS. Changing this forces a new resource to be created."
}

variable "os_disk_size_gb" {
  type        = number
  description = "(Optional) The Size of the Internal OS Disk in GB, if you wish to vary from the size used in the image this Virtual Machine is sourced from. (typically a minimum of 127GB is required)"
  default     = null
}

variable "os_disk_write_accelerator_enabled" {
  type        = bool
  description = "(Optional) Should Write Accelerator be Enabled for this OS Disk? Defaults to false."
  default     = false
}

variable "enable_boot_diagnostics" {
  type        = bool
  description = "(Optional) Enable boot diagnostics for the Virtual Machine."
  default     = false
}

variable "boot_diagnostics_storage_account_uri" {
  type        = string
  description = "(Optional) The Primary/Secondary Endpoint for the Azure Storage Account which should be used to store Boot Diagnostics, including Console Output and Screenshots from the Hypervisor. Defaults to a null value which will utilize a Managed Storage Account to store Boot Diagnostics."
  default     = null
}

variable "custom_data" {
  type        = string
  description = "(Optional) The Base64-Encoded Custom Data which should be used for this Virtual Machine. Changing this forces a new resource to be created."
  default     = null
}

variable "additional_disks" {
  description = "A Map of disk to create and attach to the VM created"
  default     = {}
}

variable "default_tags" {
  type        = map(any)
  description = "The tags to be applied to this resource"
  default     = {}
}


#####################################
#### Windows Specific variables #####
#####################################
variable "windows_enable_automatic_updates" {
  type        = bool
  description = "(Optional) Are automatic updates enabled on this Virtual Machine? Defaults to false."
  default     = false
}

variable "windows_config_timezone" {
  type        = string
  description = "(Optional) Specifies the time zone of the virtual machine, the possible values are defined here (https://jackstromberg.com/2017/01/list-of-time-zones-consumed-by-azure/)"
  default     = "GMT Standard Time"
}

variable "windows_winrm_listener" {
  type        = map(string)
  description = "(Optional) One or more winrm block ( https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine#winrm )"
  default     = null
}

variable "windows_additional_unattend_content" {
  type        = map(string)
  description = "(Optional) One or more additional_unattend_content blocks as defined in the link. Changing this forces a new resource to be created. ( https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine#additional_unattend_config )"
  default     = null
}

###################################
#### Linux Specific variables #####
###################################
variable "admin_ssh_keys" {
  type        = list(string)
  description = "A List of SSH public keys to add to the admin user account. This field is required if disable_password_authentication is set to true ( https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine#ssh_keys ). Path has been hardcoded to use the os_profile_username as the username."
  default     = null
}
