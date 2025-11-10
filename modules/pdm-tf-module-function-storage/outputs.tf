# Storage Account Outputs
output "storage_account_id" {
  description = "The ID of the storage account."
  value       = azurerm_storage_account.main.id
}

output "storage_account_name" {
  description = "The name of the storage account."
  value       = azurerm_storage_account.main.name
}

output "storage_account_primary_blob_endpoint" {
  description = "The primary blob endpoint for the storage account."
  value       = azurerm_storage_account.main.primary_blob_endpoint
}

output "storage_account_primary_access_key" {
  description = "The primary access key for the storage account. SENSITIVE."
  value       = azurerm_storage_account.main.primary_access_key
  sensitive   = true
}

output "storage_account_primary_connection_string" {
  description = "The primary connection string for the storage account. SENSITIVE."
  value       = azurerm_storage_account.main.primary_connection_string
  sensitive   = true
}

# Function App Outputs
output "function_app_id" {
  description = "The ID of the function app."
  value       = azurerm_linux_function_app.main.id
}

output "function_app_name" {
  description = "The name of the function app."
  value       = azurerm_linux_function_app.main.name
}

output "function_app_default_hostname" {
  description = "The default hostname of the function app."
  value       = azurerm_linux_function_app.main.default_hostname
}

output "function_app_identity_principal_id" {
  description = "The principal ID of the function app's managed identity."
  value       = var.enable_managed_identity ? azurerm_linux_function_app.main.identity[0].principal_id : null
}

output "function_app_identity_tenant_id" {
  description = "The tenant ID of the function app's managed identity."
  value       = var.enable_managed_identity ? azurerm_linux_function_app.main.identity[0].tenant_id : null
}

output "function_app_outbound_ip_addresses" {
  description = "Outbound IP addresses of the function app."
  value       = azurerm_linux_function_app.main.outbound_ip_addresses
}

# App Service Plan Outputs
output "app_service_plan_id" {
  description = "The ID of the app service plan."
  value       = azurerm_service_plan.main.id
}

output "app_service_plan_name" {
  description = "The name of the app service plan."
  value       = azurerm_service_plan.main.name
}

# Application Insights Outputs
output "application_insights_id" {
  description = "The ID of the Application Insights instance."
  value       = var.enable_application_insights ? azurerm_application_insights.main[0].id : null
}

output "application_insights_instrumentation_key" {
  description = "The instrumentation key for Application Insights. SENSITIVE."
  value       = var.enable_application_insights ? azurerm_application_insights.main[0].instrumentation_key : null
  sensitive   = true
}

output "application_insights_connection_string" {
  description = "The connection string for Application Insights. SENSITIVE."
  value       = var.enable_application_insights ? azurerm_application_insights.main[0].connection_string : null
  sensitive   = true
}

# Private Endpoint Outputs
output "storage_private_endpoint_id" {
  description = "The ID of the storage account private endpoint."
  value       = var.enable_private_endpoint_storage ? azurerm_private_endpoint.storage[0].id : null
}

output "function_private_endpoint_id" {
  description = "The ID of the function app private endpoint."
  value       = var.enable_private_endpoint_function ? azurerm_private_endpoint.function[0].id : null
}
