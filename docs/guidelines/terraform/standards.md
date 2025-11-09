# Terraform module development standards

This document lists pragmatic, enforceable best practices the agent should follow when authoring or reviewing Terraform modules for Azure.

## Purpose / contract
- Inputs: requested resource type, desired configuration, environment tag (dev/staging/prod), naming conventions
- Outputs: a module layout, variables with types and descriptions, outputs, examples, and a test strategy

## Module layout (inside the modules/ folder)
- README.md — module purpose, usage examples, and security notes
- main.tf — resource definitions
- variables.tf — variable definitions with types and validations
- outputs.tf — all useful outputs (mark sensitive as sensitive)
- versions.tf — provider and required_version constraints
- examples/ — one or more example usages (minimal and production-like)
- tests/ — automated tests (terratest or equivalent) or references to CI checks
- CHANGELOG.md and releases via semantic versioning
- locals.tf - any additional internal definition needs to be done in this file

    ### Module Caller layout (at the root of the project)
    - env/dev/tfvars.tf — dev specific tfvars
    - env/pp/tfvars.tf — pre-prod specific tfvars
    - env/pr/tfvars.tf — prod specific tfvars
    - main.tf — resource definitions
    - variables.tf — variable definitions with types and validations
    - backend.tf — provider and backend configuration

## Inputs, outputs, and typing
- Use explicit types for variables (string, bool, list, map, object) and provide descriptions for every variable.
- Use validation blocks for constrained values (e.g., allowed values for environment).
- Default values should be safe and secure-by-default. Avoid defaults that open public access.
- Mark sensitive outputs (for example: storage_account_primary_key) as sensitive in outputs.tf.

## Naming, tags and conventions
- Accept a `name` or `prefix` variable but allow callers to override specific resource names when required.
- Apply a consistent tagging convention via a `default_tags` map variable and merge it into resource tags. Ensure tags include at least: environment, project, owner, compliance-level.
- Terraform modules MUST be named as per the following: `pdm-tf-module-{description}`

## Providers and versions
- Constrain `required_providers` and `terraform` `required_version` in `versions.tf`.
- Do not assume provider features beyond the pinned version; prefer widely supported attributes.

## State and backends
- Modules shouldn't hardcode backend configuration. Backends are a deployment concern — document recommended backends (remote, locking) in README.

## Idempotence and lifecycle
- Modules MUST be idempotent: running `terraform apply` twice without input changes should result in no diffs.
- Use `lifecycle` blocks sparingly; prefer immutable resource replacement over ignoring drift unless there's a documented reason.

## Security and secrets
- Do not output secrets. When a module must accept keys or secrets, prefer `sensitive = true` on variables and outputs.
- Prefer Managed Identity and Azure AD authentication over shared keys. See `security.md` for per-resource baselines.

## Testing, linters and CI
- Recommend the following pipeline steps on PRs that change modules:
	1. terraform fmt
	2. terraform validate
	3. terraform init (with backend config for a test workspace) + terraform plan (ensure plan succeeds)
	4. run static checks: tflint, tfsec (security), checkov (optional)
	5. run unit/integration tests via Terratest or kitchen-terraform where feasible
- Include `ci/` job examples in README to help repo CI authors wire checks.

## Documentation
- Each module must include a README with: description, required inputs (with types), outputs, example usage, security considerations, and upgrade notes.
- Maintain a CHANGELOG when public module behavior changes.

## Versioning and releases
- Follow semantic versioning for modules. Bump major for breaking changes, minor for new features, patch for bug fixes.

## Reuse and composability
- Keep modules focused: a module should manage a single responsibility (for example: `function-app` or `storage-account`). Compose higher-level deployments from smaller modules.

## PR checklist for the agent (what the agent should enforce)
1. Does the module include `versions.tf` with pinned provider / terraform version?
2. Are variables typed and documented with descriptions and validations where needed?
3. Are all security baselines from `security.md` considered and documented as defaults or configurable toggles?
4. Are sensitive values marked sensitive and not output in plaintext?
5. Is `terraform fmt` applied and `terraform validate` passing on the example directory?
6. Are recommended CI checks documented or provided?

## Minimal module example (structure)
```
module-name/
	README.md
	main.tf
	variables.tf
	outputs.tf
	versions.tf
	examples/
	tests/
```

## How the agent should use this file
- When asked to author or review a module, the agent must follow these standards and generate a checklist of any missing items. If the user requests shortcuts (e.g., quick PoC), the agent must clearly label deviations from standards and recommend a remediation plan to bring the module up to standard before production use.

