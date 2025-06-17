
variable "csv_stateless_rule_files_directories" {
  type = list(string)
  description = "List of directories of CSV files to create stateless rule groups from"
  default = []
}

variable "csv_domain_rule_files_directories" {
  type = list(string)
  description = "List of directories of CSV files to create domain rule groups from"
  default = []
}

variable "tags" {
  type = map(string)
  default = {}
  description = "Map of strings to apply as tags to all resources"
}
