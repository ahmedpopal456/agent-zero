# Resource Group
output "resource_group_name" {
  description = "The name of the resource group"
  value       = azurerm_resource_group.example.name
}

# Storage Account
output "storage_account_name" {
  description = "The name of the storage account"
  value       = module.function_storage.storage_account_name
}

output "storage_account_id" {
  description = "The ID of the storage account"
  value       = module.function_storage.storage_account_id
}

# Function App
output "function_app_name" {
  description = "The name of the function app"
  value       = module.function_storage.function_app_name
}

output "function_app_default_hostname" {
  description = "The default hostname of the function app"
  value       = module.function_storage.function_app_default_hostname
}

output "function_app_identity_principal_id" {
  description = "The principal ID of the function app's managed identity"
  value       = module.function_storage.function_app_identity_principal_id
}

# Application Insights
output "application_insights_id" {
  description = "The ID of Application Insights"
  value       = module.function_storage.application_insights_id
}

# Log Analytics
output "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics workspace"
  value       = azurerm_log_analytics_workspace.example.id
}
