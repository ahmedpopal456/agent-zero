# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-11-09

### Added
- Initial release of Azure Function App with Storage Account module
- Storage Account with security-first defaults:
  - TLS 1.2+ enforcement
  - HTTPS-only traffic
  - Public blob access disabled by default
  - Soft delete for blobs and containers
  - Blob versioning enabled
  - Optional private endpoints
  - Network rules support
  - Diagnostic logging to Log Analytics
- Linux Function App with security features:
  - HTTPS-only enforcement
  - HTTP/2 enabled
  - System-assigned managed identity
  - Storage access via managed identity
  - Optional VNet integration
  - Optional private endpoints
  - Application Insights integration
  - Diagnostic logging
- App Service Plan with configurable SKU
- Application Insights for monitoring
- RBAC role assignment (Function to Storage)
- Comprehensive tagging strategy
- Private endpoint support for both storage and function app
- Complete documentation and examples
- Security validation against organizational baselines

### Security
- Implemented all controls from `docs/guidelines/terraform/security.md`
- Default configurations follow principle of least privilege
- Secrets marked as sensitive in outputs
- Managed identity preferred over connection strings

### Documentation
- Complete README with usage examples
- Security considerations documented
- Input/output reference tables
- Network architecture guidance
- Cost optimization recommendations
