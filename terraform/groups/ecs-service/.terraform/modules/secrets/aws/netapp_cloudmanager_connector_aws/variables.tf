variable "name" {
  type        = string
  description = "A name to be added to each of the resources created by this module"
  default     = "netapp-connector"
}

variable "build_connector" {
  type        = bool
  description = "Control whether we build the NetApp connector component or not"
  default     = true
}

variable "key_pair_name" {
  type        = string
  description = "Name of the key pair to be used when creating the connector instance"
  default     = null
}

variable "vpc_id" {
  type        = string
  description = "The Id of the VPC that this module will deploy into"
}

variable "company_name" {
  type        = string
  description = "The Company name for deployment, to be used in creating resources for NetApp"
}

variable "cvo_connector_role_names" {
  type        = list(string)
  description = "A list of CVO connector IAM role names to that the connector will be permitted to assume"
}

variable "instance_type" {
  type        = string
  description = "The instance_type that the Connector will be deployed as"
}

variable "subnet_id" {
  type        = string
  description = "The subnet_id that the Connector instance will be deployed into"
}

variable "set_public_ip" {
  type        = bool
  description = "True/False boolean for setting a public IP on the Connector instance"
  default     = false
}

variable "netapp_account_id" {
  type        = string
  default     = null
  description = "The Id of the NetApp Cloud Manager account being used"
}

variable "netapp_cvo_accountIds" {
  type        = list(string)
  default     = null
  description = "AWS account IDs for each CVO account if deployed in multiple AWS accounts, leave null if in the same account"
}

variable "ingress_ports" {
  type        = any # we need this because Terraform requires objects to be absolutely equal for lists
  description = "A list of ingress port maps that requires protocol and port to be defined and allows to_port as optional"
  default = [
    { "protocol" = "tcp", "port" = 80 },
    { "protocol" = "tcp", "port" = 443 },
    { "protocol" = "tcp", "port" = 22 },
  ]

  # we will use the new validation feature in 0.13 to do type check during plan time
  validation {
    condition     = length(var.ingress_ports) > 0 ? length([for key in var.ingress_ports : key if lookup(key, "protocol", null) != null && lookup(key, "port", null) != null]) == length(var.ingress_ports) : false
    error_message = "Ingress ports validation error, missing a required input!"
  }
}

variable "egress_ports" {
  type        = any # we need this because Terraform requires objects to be absolutely equal for lists
  description = "A list of egress port maps that requires protocol and port to be defined and allows to_port as optional"
  default = [
    { "protocol" = "icmp", "port" = 0, "to_port" = 0 },
    { "protocol" = "tcp", "port" = 0, "to_port" = 0 },
    { "protocol" = "udp", "port" = 0, "to_port" = 0 },
  ]

  # we will use the new validation feature in 0.13 to do type check during plan time
  validation {
    condition     = length(var.egress_ports) > 0 ? length([for key in var.egress_ports : key if lookup(key, "protocol", null) != null && lookup(key, "port", null) != null]) == length(var.egress_ports) : false
    error_message = "Egress ports validation error, missing a required input!"
  }
}

variable "ingress_cidr_blocks" {
  type        = list(string)
  default     = []
  description = "List of CIDR blocks to allow ingress traffic to NetApp Connector."
}

variable "egress_cidr_blocks" {
  type        = list(string)
  default     = ["0.0.0.0/0"]
  description = "List of CIDR blocks to allow egress traffic from NetApp Connector."
}

variable "ingress_security_group_ids" {
  type        = list(string)
  default     = []
  description = "List of security groups to allow ingress traffic to NetApp Connector."
}

variable "egress_security_group_ids" {
  type        = list(string)
  default     = []
  description = "List of security groups to allow egress traffic from NetApp Connector."
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default = {
    "Terraform" = "True"
  }
}
