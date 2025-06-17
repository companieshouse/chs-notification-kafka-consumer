variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

// VPC attachments
variable "vpc_attachments" {
  description = "Maps of maps of VPC details to attach to TGW. Type 'any' to disable type validation by Terraform."
  type        = any
  default     = {}
}

// Tags
variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}