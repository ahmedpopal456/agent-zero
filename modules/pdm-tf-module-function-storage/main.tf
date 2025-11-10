# Random string for unique naming
resource "random_string" "unique" {
  length  = 6
  special = false
  upper   = false
}

# Storage Account with security-first defaults
resource "azurerm_storage_account" "main" {
  name                     = local.storage_account_name_final
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_account_replication_type

  # Security: Enforce HTTPS and TLS 1.2+
  enable_https_traffic_only       = true
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = var.allow_blob_public_access

  # Security: Disable public blob access by default
  public_network_access_enabled = var.enable_private_endpoint_storage ? false : true

  # Enable blob encryption
  blob_properties {
    # Soft delete for blobs
    dynamic "delete_retention_policy" {
      for_each = var.enable_storage_soft_delete ? [1] : []
      content {
        days = var.blob_soft_delete_retention_days
      }
    }

    # Soft delete for containers
    dynamic "container_delete_retention_policy" {
      for_each = var.enable_storage_soft_delete ? [1] : []
      content {
        days = var.container_soft_delete_retention_days
      }
    }

    # Enable versioning
    versioning_enabled = var.enable_versioning
  }

  # Network rules
  dynamic "network_rules" {
    for_each = local.storage_network_rules_enabled ? [1] : []
    content {
      default_action             = "Deny"
      ip_rules                   = var.allowed_ip_ranges
      virtual_network_subnet_ids = var.enable_private_endpoint_storage && var.subnet_id_storage != null ? [var.subnet_id_storage] : []
      bypass                     = ["AzureServices"]
    }
  }

  # Identity for managed identity scenarios
  dynamic "identity" {
    for_each = var.enable_managed_identity ? [1] : []
    content {
      type = "SystemAssigned"
    }
  }

  tags = local.common_tags
}

# Storage Account Diagnostic Settings
resource "azurerm_monitor_diagnostic_setting" "storage" {
  count                      = var.enable_diagnostics && var.log_analytics_workspace_id != null ? 1 : 0
  name                       = "${azurerm_storage_account.main.name}-diagnostics"
  target_resource_id         = azurerm_storage_account.main.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  metric {
    category = "Transaction"
    enabled  = true
  }
}

# Storage Account Blob Service Diagnostic Settings
resource "azurerm_monitor_diagnostic_setting" "storage_blob" {
  count                      = var.enable_diagnostics && var.log_analytics_workspace_id != null ? 1 : 0
  name                       = "${azurerm_storage_account.main.name}-blob-diagnostics"
  target_resource_id         = "${azurerm_storage_account.main.id}/blobServices/default/"
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "StorageRead"
  }

  enabled_log {
    category = "StorageWrite"
  }

  enabled_log {
    category = "StorageDelete"
  }

  metric {
    category = "Transaction"
    enabled  = true
  }
}

# Storage Private Endpoint (optional)
resource "azurerm_private_endpoint" "storage" {
  count               = var.enable_private_endpoint_storage && var.subnet_id_storage != null ? 1 : 0
  name                = "${azurerm_storage_account.main.name}-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id_storage

  private_service_connection {
    name                           = "${azurerm_storage_account.main.name}-psc"
    private_connection_resource_id = azurerm_storage_account.main.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  tags = local.common_tags
}

# Application Insights (optional)
resource "azurerm_application_insights" "main" {
  count               = var.enable_application_insights ? 1 : 0
  name                = local.app_insights_name
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = "web"

  tags = local.common_tags
}

# App Service Plan
resource "azurerm_service_plan" "main" {
  name                = local.app_service_plan_name
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = "Linux"
  sku_name            = var.function_app_service_plan_sku

  tags = local.common_tags
}

# Linux Function App with security best practices
resource "azurerm_linux_function_app" "main" {
  name                       = local.function_app_name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  service_plan_id            = azurerm_service_plan.main.id
  storage_account_name       = azurerm_storage_account.main.name
  storage_uses_managed_identity = var.enable_managed_identity

  # Security: HTTPS only
  https_only = true

  # Enable managed identity
  dynamic "identity" {
    for_each = var.enable_managed_identity ? [1] : []
    content {
      type = "SystemAssigned"
    }
  }

  # Site configuration
  site_config {
    always_on = var.function_app_service_plan_sku != "Y1" ? var.function_always_on : false

    # Security: HTTP/2
    http2_enabled = true

    # Runtime configuration
    application_stack {
      dynamic "dotnet" {
        for_each = var.function_runtime == "dotnet" ? [1] : []
        content {
          version = var.function_runtime_version
        }
      }

      dynamic "node" {
        for_each = var.function_runtime == "node" ? [1] : []
        content {
          version = var.function_runtime_version
        }
      }

      dynamic "python" {
        for_each = var.function_runtime == "python" ? [1] : []
        content {
          version = var.function_runtime_version
        }
      }

      dynamic "java" {
        for_each = var.function_runtime == "java" ? [1] : []
        content {
          version = var.function_runtime_version
        }
      }

      dynamic "powershell_core" {
        for_each = var.function_runtime == "powershell" ? [1] : []
        content {
          version = var.function_runtime_version
        }
      }
    }

    # Application Insights
    dynamic "application_insights_connection_string" {
      for_each = var.enable_application_insights ? [1] : []
      content {
        value = azurerm_application_insights.main[0].connection_string
      }
    }

    application_insights_key = var.enable_application_insights ? azurerm_application_insights.main[0].instrumentation_key : null
  }

  # App settings
  app_settings = local.default_app_settings

  # VNet Integration for outbound traffic
  dynamic "virtual_network_subnet_id" {
    for_each = var.enable_vnet_integration && var.subnet_id_vnet_integration != null ? [var.subnet_id_vnet_integration] : []
    content {
      value = virtual_network_subnet_id.value
    }
  }

  tags = local.common_tags
}

# Grant Function App Managed Identity access to Storage Account
resource "azurerm_role_assignment" "function_storage_blob_data_owner" {
  count                = var.enable_managed_identity ? 1 : 0
  scope                = azurerm_storage_account.main.id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = azurerm_linux_function_app.main.identity[0].principal_id
}

# Function App Diagnostic Settings
resource "azurerm_monitor_diagnostic_setting" "function" {
  count                      = var.enable_diagnostics && var.log_analytics_workspace_id != null ? 1 : 0
  name                       = "${azurerm_linux_function_app.main.name}-diagnostics"
  target_resource_id         = azurerm_linux_function_app.main.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "FunctionAppLogs"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}

# Function App Private Endpoint (optional)
resource "azurerm_private_endpoint" "function" {
  count               = var.enable_private_endpoint_function && var.subnet_id_function != null ? 1 : 0
  name                = "${azurerm_linux_function_app.main.name}-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id_function

  private_service_connection {
    name                           = "${azurerm_linux_function_app.main.name}-psc"
    private_connection_resource_id = azurerm_linux_function_app.main.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }

  tags = local.common_tags
}
