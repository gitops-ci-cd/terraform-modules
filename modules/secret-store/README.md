# Secret Store

Generic module for managing secrets.

Concretely, this Terraform module is designed to retrieve secrets from HashiCorp Vault, allowing you to securely manage and access sensitive data like configurations, credentials, and keys in your Terraform configurations.

## Usage

To use this module in your Terraform configuration, specify the source module path and the required input variables like so:

```hcl
module "vault_secrets" {
  source = "../../modules/secret-store"
}
```

### Requirements

- Terraform 0.12.x and above
- Vault provider configured in your Terraform setup

### How It Works

The module includes two data sources to fetch secrets from Vault:

- `demo`: Fetches the secret stored at the path constructed from `var.secrets_path` with the name `terraform-demo`.
- `buckets`: Fetches another secret stored at the same path, named `s3-buckets`.

Both secrets are then made available through module outputs: `all_secret_values` for the `demo` secret and `buckets` for the `s3-buckets` secret. Outputs marked as sensitive will not be displayed in Terraform's CLI output.

## Considerations

- Ensure that the Vault server is accessible from where Terraform is run and that the provided path (`var.secrets_path`) is correct and the secrets exist.
- The `secrets_path` variable allows you to specify where the secrets are located within Vault, providing flexibility to structure your Vault secrets as needed.
- Since the `all_secret_values output` is marked as sensitive, it won't be displayed in Terraform plans or applies, but it can still be referenced by other Terraform configurations.

For more information on managing secrets in Vault, refer to the [Vault documentation](https://registry.terraform.io/providers/hashicorp/vault/latest/docs).
