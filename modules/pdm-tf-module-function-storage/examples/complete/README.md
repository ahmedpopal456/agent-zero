# Complete Example - Azure Function App with Storage Account

This example demonstrates a complete deployment of the `pdm-tf-module-function-storage` module with all recommended configurations.

## What This Example Creates

- Resource Group
- Log Analytics Workspace
- Storage Account (with security defaults)
- Azure Function App (Linux)
- App Service Plan
- Application Insights
- RBAC role assignments
- Diagnostic settings

## Prerequisites

- Azure subscription
- Azure CLI or Service Principal credentials
- Terraform >= 1.5.0

## Usage

1. **Initialize Terraform:**
   ```bash
   terraform init
   ```

2. **Review the plan:**
   ```bash
   terraform plan
   ```

3. **Apply the configuration:**
   ```bash
   terraform apply
   ```

4. **View outputs:**
   ```bash
   terraform output
   ```

5. **Cleanup:**
   ```bash
   terraform destroy
   ```

## Customization

### For Development Environment
```bash
terraform apply -var="environment=dev" -var="name_prefix=myapp"
```

### For Production Environment
```bash
terraform apply -var="environment=prod" -var="name_prefix=myapp"
```

The configuration automatically adjusts based on environment:
- **Dev**: Consumption plan (Y1), LRS storage
- **Prod**: Elastic Premium (EP1), GRS storage, always_on enabled

## Testing the Deployment

After deployment, test the function app:

```bash
# Get the function app hostname
FUNCTION_APP=$(terraform output -raw function_app_default_hostname)

# Test the endpoint (replace with your function name)
curl https://$FUNCTION_APP/api/YourFunctionName
```

## Security Notes

This example follows all security baselines:
- ✅ TLS 1.2+ enforced
- ✅ HTTPS only
- ✅ Public blob access disabled
- ✅ Managed identity enabled
- ✅ Diagnostic logging configured
- ✅ Soft delete enabled
- ✅ Versioning enabled

## Cost Estimate

Approximate monthly costs (US East 2):
- **Dev environment**: ~$15-25/month (Consumption plan)
- **Prod environment**: ~$150-200/month (EP1 plan)

Actual costs may vary based on usage and data transfer.
