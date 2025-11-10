variable "name_prefix" {
  description = "Prefix for resource names. Will be used to generate unique names for storage account and function app."
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9]{3,10}$", var.name_prefix))
    error_message = "Name prefix must be 3-10 characters, lowercase alphanumeric only."
  }
}

variable "location" {
  description = "Azure region for all resources."
  type        = string
  default     = "eastus2"
}

variable "resource_group_name" {
  description = "Name of the resource group where resources will be created."
  type        = string
}

variable "environment" {
  description = "Environment tag (dev, staging, prod)."
  type        = string
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

variable "project" {
  description = "Project name for tagging."
  type        = string
}

variable "owner" {
  description = "Owner email or team name for tagging."
  type        = string
}

variable "compliance_level" {
  description = "Compliance level for data classification (standard, sensitive, restricted)."
  type        = string
  default     = "standard"
  validation {
    condition     = contains(["standard", "sensitive", "restricted"], var.compliance_level)
    error_message = "Compliance level must be one of: standard, sensitive, restricted."
  }
}

# Storage Account Variables
variable "storage_account_tier" {
  description = "Performance tier for storage account (Standard or Premium)."
  type        = string
  default     = "Standard"
  validation {
    condition     = contains(["Standard", "Premium"], var.storage_account_tier)
    error_message = "Storage account tier must be Standard or Premium."
  }
}

variable "storage_account_replication_type" {
  description = "Replication type for storage account (LRS, GRS, RAGRS, ZRS, GZRS, RAGZRS)."
  type        = string
  default     = "LRS"
  validation {
    condition     = contains(["LRS", "GRS", "RAGRS", "ZRS", "GZRS", "RAGZRS"], var.storage_account_replication_type)
    error_message = "Invalid replication type."
  }
}

variable "allow_blob_public_access" {
  description = "Allow public access to blobs. SECURITY: Should be false unless explicitly required."
  type        = bool
  default     = true
}

variable "enable_storage_soft_delete" {
  description = "Enable soft delete for blobs."
  type        = bool
  default     = true
}

variable "blob_soft_delete_retention_days" {
  description = "Number of days to retain soft-deleted blobs."
  type        = number
  default     = 7
  validation {
    condition     = var.blob_soft_delete_retention_days >= 1 && var.blob_soft_delete_retention_days <= 365
    error_message = "Retention days must be between 1 and 365."
  }
}

variable "container_soft_delete_retention_days" {
  description = "Number of days to retain soft-deleted containers."
  type        = number
  default     = 7
  validation {
    condition     = var.container_soft_delete_retention_days >= 1 && var.container_soft_delete_retention_days <= 365
    error_message = "Retention days must be between 1 and 365."
  }
}

variable "enable_versioning" {
  description = "Enable blob versioning."
  type        = bool
  default     = true
}

variable "enable_private_endpoint_storage" {
  description = "Enable private endpoint for storage account."
  type        = bool
  default     = false
}

variable "subnet_id_storage" {
  description = "Subnet ID for storage account private endpoint (required if enable_private_endpoint_storage is true)."
  type        = string
  default     = null
}

# Function App Variables
variable "function_app_service_plan_sku" {
  description = "SKU for the App Service Plan (Y1 for consumption, EP1/EP2/EP3 for elastic premium, P1V2/P2V2/P3V2 for premium)."
  type        = string
  default     = "Y1"
}

variable "function_runtime" {
  description = "Function app runtime (dotnet, node, python, java, powershell)."
  type        = string
  default     = "dotnet"
  validation {
    condition     = contains(["dotnet", "node", "python", "java", "powershell"], var.function_runtime)
    error_message = "Runtime must be one of: dotnet, node, python, java, powershell."
  }
}

variable "function_runtime_version" {
  description = "Runtime version (e.g., '6' for dotnet 6, '18' for node 18, '3.9' for python 3.9)."
  type        = string
  default     = "6"
}

variable "function_always_on" {
  description = "Should the function app be always on? Recommended for production."
  type        = bool
  default     = true
}

variable "enable_application_insights" {
  description = "Enable Application Insights for monitoring."
  type        = bool
  default     = true
}

variable "enable_managed_identity" {
  description = "Enable system-assigned managed identity for the function app."
  type        = bool
  default     = true
}

variable "enable_private_endpoint_function" {
  description = "Enable private endpoint for function app."
  type        = bool
  default     = false
}

variable "subnet_id_function" {
  description = "Subnet ID for function app private endpoint (required if enable_private_endpoint_function is true)."
  type        = string
  default     = null
}

variable "enable_vnet_integration" {
  description = "Enable VNet integration for outbound traffic from function app."
  type        = bool
  default     = false
}

variable "subnet_id_vnet_integration" {
  description = "Subnet ID for VNet integration (required if enable_vnet_integration is true)."
  type        = string
  default     = null
}

variable "app_settings" {
  description = "Additional app settings for the function app."
  type        = map(string)
  default     = {}
  sensitive   = true
}

# Diagnostics Variables
variable "log_analytics_workspace_id" {
  description = "Log Analytics workspace ID for diagnostic logs."
  type        = string
  default     = null
}

variable "enable_diagnostics" {
  description = "Enable diagnostic settings for storage account and function app."
  type        = bool
  default     = true
}

# Network Security Variables
variable "allowed_ip_ranges" {
  description = "List of IP ranges allowed to access storage account (CIDR format)."
  type        = list(string)
  default     = []
}

variable "default_tags" {
  description = "Additional tags to merge with default tags."
  type        = map(string)
  default     = {}
}
