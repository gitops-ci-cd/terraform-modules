# Certificate

This module provisions an AWS Certificate Manager (ACM) certificate with support for both DNS and email validation. Optionally, it creates DNS validation records using Route 53.

---

## Usage

### Example: Public Certificate with DNS Validation

```hcl
module "certificate" {
  source = "../../modules/certificate"

  domain_name = "example.com"
  subject_alternative_names = ["www.example.com"]
  zone_id = "Z3P5QSUBK4POTI"

  tags = {
    Environment = "production"
    Team        = "platform"
  }
}
```

### Features

1. DNS or Email Validation
    - Supports DNS validation using Route 53 or email-based validation.
2. Subject Alternative Names
    - Optionally add multiple domain names for the certificate.
3. Outputs for DNS Validation
    - Provides validation records for easy integration with external DNS providers.

## Considerations

1. Public vs Private Certificates
    - This module supports public ACM certificates only. Private certificates for use with private CAs require additional configurations.
2. Route 53 Requirement
    - For DNS validation, ensure the domain is hosted in the specified Route 53 zone.
3. Validation Time
    - DNS validation certificates are automatically issued once the records propagate.
    - Email validation requires manual approval from the domain’s contact email.
4. Regional Scope
    - ACM certificates are regional. Ensure the Terraform AWS provider is configured for the correct region.
