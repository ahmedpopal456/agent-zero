# Test Documentation

This directory is reserved for automated tests using tools like Terratest or kitchen-terraform.

## Recommended Test Structure

```
tests/
  ├── basic_test.go              # Basic deployment test
  ├── security_test.go           # Security configuration validation
  ├── integration_test.go        # Integration tests
  └── README.md                  # This file
```

## Test Strategy

### Unit Tests
- Validate variable constraints
- Check default values
- Test input validations

### Integration Tests
- Deploy module to test subscription
- Verify resources created correctly
- Validate security configurations
- Check RBAC assignments
- Test managed identity access
- Verify diagnostic settings

### Security Tests
- Ensure TLS 1.2+ is enforced
- Verify public access is disabled
- Check managed identity configuration
- Validate network rules
- Verify encryption settings

## Running Tests with Terratest (Example)

```bash
# Install Go if not already installed
# brew install go (macOS)

# Initialize Go module
go mod init tests
go get github.com/gruntwork-io/terratest/modules/terraform
go get github.com/gruntwork-io/terratest/modules/azure
go get github.com/stretchr/testify/assert

# Run tests
go test -v -timeout 30m
```

## Example Terratest (basic_test.go)

```go
package test

import (
    "testing"
    "github.com/gruntwork-io/terratest/modules/terraform"
    "github.com/stretchr/testify/assert"
)

func TestBasicDeployment(t *testing.T) {
    t.Parallel()

    terraformOptions := &terraform.Options{
        TerraformDir: "../examples/complete",
        Vars: map[string]interface{}{
            "name_prefix": "test",
            "environment": "dev",
        },
    }

    defer terraform.Destroy(t, terraformOptions)
    terraform.InitAndApply(t, terraformOptions)

    // Validate outputs
    functionAppName := terraform.Output(t, terraformOptions, "function_app_name")
    assert.NotEmpty(t, functionAppName)
}
```

## CI/CD Integration

Add to your pipeline:

```yaml
# Azure DevOps example
- task: GoTool@0
  inputs:
    version: '1.21'

- script: |
    cd tests
    go mod download
    go test -v -timeout 30m
  displayName: 'Run Terratest'
```

## Manual Testing Checklist

- [ ] Module deploys successfully
- [ ] All resources created with correct names
- [ ] Tags applied correctly
- [ ] Managed identity enabled
- [ ] Storage account has TLS 1.2+
- [ ] Public blob access disabled
- [ ] Soft delete enabled
- [ ] Function app uses HTTPS only
- [ ] Application Insights connected
- [ ] Diagnostic logs flowing to Log Analytics
- [ ] RBAC role assigned correctly

## Future Enhancements

- Add automated security scanning (tfsec, checkov)
- Implement cost validation tests
- Add performance benchmarks
- Create chaos engineering tests
