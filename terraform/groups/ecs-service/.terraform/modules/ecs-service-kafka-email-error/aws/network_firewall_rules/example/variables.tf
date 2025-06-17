variable "name" {
  type = string
  default = "examplefirewall"
}

variable "tags" {
  type = map(string)
  default = {}
  description = "Map of strings to apply as tags to all resources"
}
