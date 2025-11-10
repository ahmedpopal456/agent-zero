# Create a resource group for the example
resource "azurerm_resource_group" "example" {
  name     = "rg-example-function-storage-${var.environment}"
  location = var.location

  tags = {
    environment = var.environment
    project     = "example"
    managed-by  = "terraform"
  }
}

# Optional: Create Log Analytics workspace for diagnostics
resource "azurerm_log_analytics_workspace" "example" {
  name                = "law-example-${var.environment}"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = {
    environment = var.environment
    project     = "example"
    managed-by  = "terraform"
  }
}

# Call the module
module "function_storage" {
  source = "../../"

  name_prefix         = var.name_prefix
  environment         = var.environment
  location            = var.location
  resource_group_name = azurerm_resource_group.example.name
  project             = "example-project"
  owner               = "team@example.com"
  compliance_level    = "standard"

  # Storage Account configuration
  storage_account_tier             = "Standard"
  storage_account_replication_type = var.environment == "prod" ? "GRS" : "LRS"
  allow_blob_public_access         = false
  enable_storage_soft_delete       = true
  blob_soft_delete_retention_days  = 7
  enable_versioning                = true

  # Function App configuration
  function_app_service_plan_sku = var.environment == "prod" ? "EP1" : "Y1"
  function_runtime              = "dotnet"
  function_runtime_version      = "6"
  function_always_on            = var.environment == "prod" ? true : false

  # Monitoring
  enable_application_insights = true
  enable_diagnostics          = true
  log_analytics_workspace_id  = azurerm_log_analytics_workspace.example.id

  # Managed Identity
  enable_managed_identity = true

  # Additional app settings
  app_settings = {
    "ENVIRONMENT_NAME" = var.environment
    "EXAMPLE_SETTING"  = "example-value"
  }

  default_tags = {
    "example-tag" = "example-value"
  }
}
