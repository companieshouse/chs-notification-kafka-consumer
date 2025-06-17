variable "tgw_routes_to_create" {
  description = "Map of routes to create and the designated route table to use"
  type        = list(any)
  default     = []
}

variable "tgw_route_table_association" {
  description = "Map of route table associations for tgw attachments"
  type        = list(any)
  default     = []
}

variable "tgw_route_table_propagate" {
  description = "Map of routes to propagate for tgw attachments"
  type        = list(any)
  default     = []
}

