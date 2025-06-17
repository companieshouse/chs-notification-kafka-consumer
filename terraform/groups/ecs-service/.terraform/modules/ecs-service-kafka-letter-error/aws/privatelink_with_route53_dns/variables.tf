variable "service_name" {
  type        = string
  description = "(Required) The service name. This should be only the service name not the fully qualified name i.e. `com.amazonaws.<region>.<service>` region will be supplied within the module"
}

variable "private_dns_enabled" {
  type        = bool
  description = "(Optional) Defaults to true, set to false if you want to host your own Route53 private hosted zone for this Endpoint, other wise AWS will create an unshareable zone for the endpoint"
  default     = true
}

variable "vpc_id" {
  type        = string
  description = "(Required) The VPC Id that this Endpoint will be created in"
}

variable "security_group_ids" {
  type        = list(string)
  description = "(Required) A list of existing security group IDs that will apply to the endpoint."
}

variable "subnet_ids" {
  type        = list(string)
  description = "(Required) A list of subnet Ids to create each endpoint in, one per availability zone but can be a single subnet Id if multi-az is not required"
}

variable "route53_comment" {
  type        = string
  description = "(Optional) A comment for the hosted zone. Defaults to 'Managed by Terraform'."
  default     = "Managed by Terraform"
}

variable "route53_force_destroy" {
  type        = bool
  description = "(Optional) Whether to destroy all records (possibly managed outside of Terraform) in the zone when destroying the zone."
  default     = true
}

variable "tags" {
  type        = map(any)
  description = "(Optional) A map of tag keys and values to apply to the module resources"
  default     = {}
}
