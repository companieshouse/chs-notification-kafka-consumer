
variable "name" {
  type        = string
  description = "Name to use for resources created by this example"
  default     = null
}

variable "kmsadmin_principals" {
  type        = list(string)
  description = "KMS Admin IAM Principals"
  default     = null
}

variable "kmsuser_principals" {
  type        = list(string)
  description = "KMS User IAM Principals"
  default     = null
}