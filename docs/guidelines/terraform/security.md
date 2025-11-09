# Terraform security baselines for Azure resources

This document defines minimal security baselines for Azure resources that the agent MUST consider when generating or modifying Terraform modules. The focus below is on Azure Functions and Azure Storage Accounts because they are commonly used together and have important security configuration options that prevent common misconfigurations.

These baselines are intended to be merged into Terraform modules as default settings (configurable via variables) and used as checklist items during PR reviews.

## Contract (for the agent)
- Inputs: resource type, module inputs/variables, environment (dev/staging/prod)
- Outputs: recommended Terraform settings, validation checklist, example variable names and descriptions
- Error modes: if a required security control cannot be applied (e.g., private endpoint not available in region), list the gap and provide mitigations

## General rules
- Enforce TLS 1.2+ (set minimum TLS version on services and SDKs)
- Enable diagnostic logging and send logs to a central Log Analytics workspace or Storage Account
- Use Managed Identity (system-assigned or user-assigned) wherever possible instead of shared keys
- Tag resources with environment, project, owner, and compliance-level
- Use RBAC (Azure role assignments) instead of shared access keys when possible
- Enable Azure Defender (where available) and follow recommendations

## Azure Functions baseline
- Identity
	- Prefer System-assigned or User-assigned Managed Identity for the Function App; do not embed credentials in settings.
	- When accessing other Azure services, grant least-privilege RBAC roles to the function's identity.
- Networking
	- Deploy into a VNet using VNet integration for outbound and Private Endpoint for inbound access to Function App if needed (App Service Environment if high isolation is required).
	- Disable public access to underlying resources when private endpoints are used.
- Runtime & configuration
	- Set WEBSITE_HTTP2_ONLY = true where applicable.
	- Set always_on = true for production functions that must remain warm (configurable by environment variable).
	- Store app secrets in Azure Key Vault and reference them using the Key Vault references feature (managed identity required).
	- Disable the runtime management endpoints unless explicitly required and protected.
	- Enable function-level authentication/authorization (Easy Auth) or front the app with API Management when appropriate.
- Storage and keys
	- Avoid storing sensitive data in application settings; use Key Vault references instead.
	- Turn off 'Always On' only for non-production environments where cost is a priority and startup times are acceptable.
- Monitoring & protection
	- Enable Application Insights for telemetry and set sampling appropriately for production.
	- Enable Diagnostic Settings to send Function App logs to Log Analytics and/or storage and event hub.
	- Ensure runtime logs do not contain secrets; enforce secret scrubbing in logs.

## Azure Storage Account baseline
- Network & access
	- Require secure transfer (enable secure_transport / minimum TLS 1.2).
	- Disable public blob access at account level unless explicitly required: allow_blob_public_access = false.
	- Use Private Endpoints and service endpoints; restrict network access via firewall rules and virtual network rules.
	- When using Shared Access Signatures (SAS), scope them narrowly and set short expirations; prefer Azure AD authentication and RBAC for access.
- Encryption & keys
	- Enable encryption at rest (Microsoft-managed keys by default). For additional control, allow customer-managed keys (CMK) via Key Vault as configurable option.
	- If CMK is requested, ensure Key Vault access policies and RBAC are configured and monitor key rotation.
- Data protection
	- Enable soft delete for blobs and containers where recoverability is required.
	- Enable blob immutability (versioning/immutability policy) if required by compliance.
	- Enable lifecycle management rules to transition or delete stale data.
- Monitoring & logging
	- Enable Diagnostic Settings to stream Storage logs to Log Analytics / Event Hub / Storage Account.
	- Enable Storage Analytics metrics and set retention according to retention policy.
- Performance & tiering
	- Choose appropriate access tiers and set lifecycle rules to move data to cooler tiers when appropriate.

## Module-level recommendations (how the agent should generate Terraform)
- Make security controls configurable but default to the secure option (e.g., private_endpoint_enabled = false -> default true in production environment templates).
- Use boolean variables to toggle risky features (e.g., allow_blob_public_access, enable_plaintext_access) and mark them as sensitive in module docs.
- Provide examples and a `security` checklist in each module README listing required terraform plan diff lines to watch for (e.g., any change enabling public access or removing diagnostic settings).
- Document dependencies (e.g., Key Vault for CMK) and required RBAC roles for the module to function without manual steps.

## PR review checklist (agent should include this when opening or commenting on PRs that create/modify these resources)
1. Is TLS minimum set to 1.2 or higher?
2. Is diagnostic logging enabled and pointed to a central workspace/account?
3. Are managed identities used instead of embedding secrets?
4. Is public access disabled for Storage unless explicitly required and documented?
5. Are private endpoints or network rules applied where applicable?
6. Is encryption at rest configured and does it allow CMK when requested?
7. Are SAS tokens scoped and short-lived where used?
8. Are lifecycle and soft-delete policies configured for critical data?

## How the agent should surface gaps
- If a requested configuration cannot be implemented by Terraform (provider limitation or missing Azure feature in the region), the agent MUST list the limitation, possible mitigations, and a recommended operational procedure.
- If security defaults are changed from the recommended baseline, the agent should add a clear comment explaining the risk and required approvals (who, why, and for how long).

---

This file is intended as authoritative guidance for the agent when authoring or reviewing Terraform modules that create or manage Azure Functions and Storage Accounts. Keep it minimal and prescriptive: prefer settings that fail closed (secure-by-default) and make exceptions opt-in with explicit justification.

