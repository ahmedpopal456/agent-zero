locals {
  # Generate unique names
  storage_account_name = lower(replace("${var.name_prefix}${var.environment}sa${random_string.unique.result}", "-", ""))
  function_app_name    = "${var.name_prefix}-${var.environment}-func-${random_string.unique.result}"
  app_service_plan_name = "${var.name_prefix}-${var.environment}-asp-${random_string.unique.result}"
  app_insights_name    = "${var.name_prefix}-${var.environment}-ai-${random_string.unique.result}"

  # Ensure storage account name is within Azure limits (3-24 chars, lowercase alphanumeric)
  storage_account_name_final = substr(local.storage_account_name, 0, min(24, length(local.storage_account_name)))

  # Merged tags
  common_tags = merge(
    {
      environment      = var.environment
      project          = var.project
      owner            = var.owner
      compliance-level = var.compliance_level
      managed-by       = "terraform"
      architecture     = "compute-storage"
    },
    var.default_tags
  )

  # App settings with security best practices
  default_app_settings = merge(
    {
      FUNCTIONS_WORKER_RUNTIME              = var.function_runtime
      FUNCTIONS_EXTENSION_VERSION           = "~4"
      WEBSITE_RUN_FROM_PACKAGE              = "1"
      AzureWebJobsStorage__accountName      = azurerm_storage_account.main.name
      WEBSITE_CONTENTAZUREFILECONNECTIONSTRING = ""  # Using managed identity
      WEBSITE_CONTENTSHARE                  = "${local.function_app_name}-content"
      WEBSITE_ENABLE_SYNC_UPDATE_SITE       = "true"
      WEBSITE_HTTP20_ONLY                   = "true"
      SCM_DO_BUILD_DURING_DEPLOYMENT        = "false"
    },
    var.enable_application_insights ? {
      APPINSIGHTS_INSTRUMENTATIONKEY             = azurerm_application_insights.main[0].instrumentation_key
      APPLICATIONINSIGHTS_CONNECTION_STRING      = azurerm_application_insights.main[0].connection_string
      ApplicationInsightsAgent_EXTENSION_VERSION = "~3"
    } : {},
    var.app_settings
  )

  # Network configuration
  storage_network_rules_enabled = length(var.allowed_ip_ranges) > 0 || var.enable_private_endpoint_storage
}
