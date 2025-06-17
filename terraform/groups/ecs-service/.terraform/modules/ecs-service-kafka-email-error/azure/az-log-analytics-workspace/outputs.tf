output "la_workspace_id" {
  value       = azurerm_log_analytics_workspace.this.id
  description = "The azure ID used within the Azure platform"
}

output "la_workspace_primary_key" {
  value       = azurerm_log_analytics_workspace.this.primary_shared_key
  description = "The primary key that allows agents to connect to the workspace"
}

output "la_workspace_secondary_key" {
  value       = azurerm_log_analytics_workspace.this.secondary_shared_key
  description = "The secondary key that allows agents to connect to the workspace"
}

output "la_workspace_workspace_id" {
  value       = azurerm_log_analytics_workspace.this.workspace_id
  description = "The ID that is used to connect agents to the workspace"
}