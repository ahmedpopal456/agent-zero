# Azure Function App with Storage Account Terraform Module

## Overview
This Terraform module deploys an Azure Function App with an associated Storage Account, following security-first best practices and Azure Well-Architected Framework principles.

## Features
- **Security-First Defaults**: TLS 1.2+, HTTPS-only, disabled public blob access by default
- **Managed Identity**: System-assigned managed identity enabled by default for secure Azure service access
- **Monitoring**: Application Insights integration and diagnostic logging to Log Analytics
- **Network Security**: Optional private endpoints and VNet integration
- **Data Protection**: Blob soft delete, versioning, and lifecycle policies
- **Compliance**: Comprehensive tagging strategy for governance and cost tracking

## Security Considerations
This module implements the security baselines defined in `docs/guidelines/terraform/security.md`:

### Storage Account Security
- ✅ TLS 1.2+ enforced (`min_tls_version = "TLS1_2"`)
- ✅ HTTPS traffic only (`enable_https_traffic_only = true`)
- ✅ Public blob access disabled by default (`allow_blob_public_access = false`)
- ✅ Network rules with deny-by-default when private endpoints enabled
- ✅ Soft delete enabled for blobs and containers
- ✅ Blob versioning enabled by default
- ✅ Diagnostic logging to Log Analytics
- ✅ Encryption at rest (Microsoft-managed keys by default)

### Function App Security
- ✅ HTTPS only (`https_only = true`)
- ✅ HTTP/2 enabled (`http2_enabled = true`)
- ✅ System-assigned managed identity enabled by default
- ✅ Storage access via managed identity (no connection strings)
- ✅ Application Insights for monitoring
- ✅ Diagnostic logging enabled
- ✅ Optional VNet integration for outbound traffic
- ✅ Optional private endpoint for inbound access

## Usage

### Basic Example
```hcl
module "function_storage" {
  source = "./modules/pdm-tf-module-function-storage"

  name_prefix         = "myapp"
  environment         = "dev"
  location            = "eastus2"
  resource_group_name = azurerm_resource_group.main.name
  project             = "my-project"
  owner               = "team@example.com"

  function_runtime         = "dotnet"
  function_runtime_version = "6"
}
```

### Production Example with Private Endpoints
```hcl
module "function_storage" {
  source = "./modules/pdm-tf-module-function-storage"

  name_prefix         = "myapp"
  environment         = "prod"
  location            = "eastus2"
  resource_group_name = azurerm_resource_group.main.name
  project             = "my-project"
  owner               = "team@example.com"
  compliance_level    = "sensitive"

  # Storage configuration
  storage_account_replication_type = "GRS"
  allow_blob_public_access         = false
  enable_private_endpoint_storage  = true
  subnet_id_storage                = azurerm_subnet.storage_pe.id

  # Function configuration
  function_app_service_plan_sku    = "EP1"
  function_runtime                 = "dotnet"
  function_runtime_version         = "6"
  function_always_on               = true
  enable_vnet_integration          = true
  subnet_id_vnet_integration       = azurerm_subnet.function_vnet.id
  enable_private_endpoint_function = true
  subnet_id_function               = azurerm_subnet.function_pe.id

  # Monitoring
  enable_application_insights = true
  enable_diagnostics          = true
  log_analytics_workspace_id  = azurerm_log_analytics_workspace.main.id

  # Additional app settings
  app_settings = {
    "CUSTOM_SETTING" = "value"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.5.0 |
| azurerm | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| azurerm | ~> 3.0 |
| random | latest |

## Required Inputs

| Name | Description | Type | Validation |
|------|-------------|------|------------|
| name_prefix | Prefix for resource names (3-10 chars, lowercase alphanumeric) | `string` | `^[a-z0-9]{3,10}$` |
| resource_group_name | Name of the resource group | `string` | - |
| environment | Environment tag (dev, staging, prod) | `string` | Must be: dev, staging, prod |
| project | Project name for tagging | `string` | - |
| owner | Owner email or team name | `string` | - |

## Optional Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| location | Azure region | `string` | `eastus2` |
| compliance_level | Compliance level (standard, sensitive, restricted) | `string` | `standard` |
| storage_account_tier | Storage tier (Standard, Premium) | `string` | `Standard` |
| storage_account_replication_type | Replication type | `string` | `LRS` |
| allow_blob_public_access | Allow public blob access (SECURITY: use false) | `bool` | `false` |
| enable_storage_soft_delete | Enable blob soft delete | `bool` | `true` |
| blob_soft_delete_retention_days | Soft delete retention (1-365 days) | `number` | `7` |
| enable_versioning | Enable blob versioning | `bool` | `true` |
| enable_private_endpoint_storage | Enable storage private endpoint | `bool` | `false` |
| subnet_id_storage | Subnet ID for storage PE | `string` | `null` |
| function_app_service_plan_sku | App Service Plan SKU | `string` | `Y1` |
| function_runtime | Runtime (dotnet, node, python, java, powershell) | `string` | `dotnet` |
| function_runtime_version | Runtime version | `string` | `6` |
| function_always_on | Always on (recommended for prod) | `bool` | `true` |
| enable_application_insights | Enable Application Insights | `bool` | `true` |
| enable_managed_identity | Enable system-assigned MI | `bool` | `true` |
| enable_vnet_integration | Enable VNet integration | `bool` | `false` |
| subnet_id_vnet_integration | Subnet ID for VNet integration | `string` | `null` |
| enable_private_endpoint_function | Enable function PE | `bool` | `false` |
| subnet_id_function | Subnet ID for function PE | `string` | `null` |
| log_analytics_workspace_id | Log Analytics workspace ID | `string` | `null` |
| enable_diagnostics | Enable diagnostic settings | `bool` | `true` |
| allowed_ip_ranges | Allowed IP ranges (CIDR) | `list(string)` | `[]` |
| app_settings | Additional app settings | `map(string)` | `{}` |

## Outputs

| Name | Description | Sensitive |
|------|-------------|-----------|
| storage_account_id | Storage account ID | No |
| storage_account_name | Storage account name | No |
| storage_account_primary_blob_endpoint | Primary blob endpoint | No |
| storage_account_primary_access_key | Primary access key | Yes |
| storage_account_primary_connection_string | Primary connection string | Yes |
| function_app_id | Function app ID | No |
| function_app_name | Function app name | No |
| function_app_default_hostname | Function app hostname | No |
| function_app_identity_principal_id | Managed identity principal ID | No |
| function_app_identity_tenant_id | Managed identity tenant ID | No |
| app_service_plan_id | App Service Plan ID | No |
| application_insights_id | Application Insights ID | No |
| application_insights_instrumentation_key | App Insights instrumentation key | Yes |
| application_insights_connection_string | App Insights connection string | Yes |

## Resources Created
- Azure Storage Account with security configurations
- Azure Function App (Linux)
- App Service Plan
- Application Insights (optional)
- Private Endpoints (optional)
- Diagnostic Settings
- RBAC role assignments (managed identity to storage)

## Network Architecture
When private endpoints are enabled:
- Storage Account: Private endpoint on specified subnet
- Function App: Private endpoint for inbound, VNet integration for outbound

## Monitoring & Diagnostics
- Application Insights for function app telemetry
- Diagnostic logs sent to Log Analytics workspace
- Storage transaction logs and metrics
- Function app execution logs

## Tagging Strategy
All resources are tagged with:
- `environment`: dev, staging, prod
- `project`: Project name
- `owner`: Team or individual
- `compliance-level`: standard, sensitive, restricted
- `managed-by`: terraform
- `architecture`: compute-storage

## Cost Optimization
- Use consumption plan (Y1) for dev/test environments
- Enable always_on only for production workloads
- Consider storage tiering and lifecycle policies
- Use appropriate replication type per environment (LRS for dev, GRS for prod)

## Upgrade Notes
When upgrading this module:
1. Review CHANGELOG.md for breaking changes
2. Run `terraform plan` to preview changes
3. Test in non-production environment first
4. Update version constraints in your root module

## Testing
See `examples/complete` for a complete working example.

Run validation:
```bash
cd examples/complete
terraform init
terraform validate
terraform fmt -check
```

## CI/CD Integration
Recommended pipeline steps:
1. `terraform fmt -check`
2. `terraform validate`
3. `tfsec .` or `checkov -d .`
4. `terraform plan`
5. Manual approval for production
6. `terraform apply`

## Dependencies
- Existing resource group
- (Optional) Virtual Network and subnets for private endpoints
- (Optional) Log Analytics workspace for diagnostics

## Limitations
- Storage account name limited to 24 characters (auto-truncated)
- Always_on not available for consumption plan (Y1)
- Private endpoints require appropriate network configuration

## Support
For issues or questions, please refer to:
- Security baseline: `docs/guidelines/terraform/security.md`
- Module standards: `docs/guidelines/terraform/standards.md`

## License
Internal use only - follow organizational policies.
