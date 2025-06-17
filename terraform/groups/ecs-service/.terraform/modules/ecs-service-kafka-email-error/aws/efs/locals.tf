locals {
  service_name_prefix = "${var.environment}-${var.service}"

  file_system_client_root_access = var.permit_client_root_access ? [
    "elasticfilesystem:ClientRootAccess"
  ] : []

  default_tags = {
    Environment = var.environment
    Service     = var.service
  }
}
