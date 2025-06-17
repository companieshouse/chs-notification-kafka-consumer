variable "region" {
  description = "AWS Region"
  type        = string
}

variable "azs" {
  description = "List of AZs to manage using only the letters, not full AZ name e.g. (a, b, c)"
  type        = list
  default     = ["a", "b", "c"]
}