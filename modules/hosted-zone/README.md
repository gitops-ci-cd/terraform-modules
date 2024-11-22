# Hosted Zone

Generic module for managing domains and subdomains.

This module creates AWS Route 53 Hosted Zones, supporting both public and private hosted zones. For private hosted zones, you can associate multiple VPCs, enabling DNS resolution within those VPCs.

## Usage

Example 1: Public Hosted Zone

```hcl
module "public_hosted_zone" {
  source = "../../modules/hosted-zone"

  name = "example.com"
  tags = {
    Environment = "production"
  }
}
```

Example 2: Private Hosted Zone

```hcl
module "private_hosted_zone" {
  source  = "../../modules/hosted-zone"
  name    = "internal.example.com"
  vpc_ids = ["vpc-12345678", "vpc-87654321"]
  tags = {
    Environment = "development"
  }
}
```

### Features

1. Public and Private Zones:
    - Create public hosted zones accessible over the internet.
    - Create private hosted zones scoped to one or more VPCs for internal DNS resolution.
1. VPC Associations:
    - Automatically associate private hosted zones with one or more VPCs.
1. Tagging:
    - Apply custom tags for better resource organization.

### Example Outputs

For Public Hosted Zone:

```hcl
output "public_zone_name_servers" {
  value = module.public_hosted_zone.name_servers
}

# [
#   "ns-123.awsdns-12.com",
#   "ns-456.awsdns-34.org",
#   "ns-789.awsdns-56.net",
#   "ns-101.awsdns-78.co.uk"
# ]
```

For Private Hosted Zone:

```hcl
output "private_zone_id" {
  value = module.private_hosted_zone.zone_id
}

# "Z1D633PJN98FT9"
```

## Considerations

1. Domain Registration:
    - For public hosted zones, you must configure your domain registrar to use the nameservers provided by AWS Route 53.
1. VPC DNS Configuration:
    - For private hosted zones, ensure the associated VPCs have DNS resolution and DNS hostnames enabled:

      ```hcl
      resource "aws_vpc" "example" {
        enable_dns_support   = true
        enable_dns_hostnames = true
      }
      ```

1. Split Horizon:
    - To manage both internal and external DNS for the same domain, use a public hosted zone for example.com and a private hosted zone for internal.example.com.

## Advanced Usage

Integration with DNS Records Module

You can use the hosted zone outputs (zone_id) to dynamically create DNS records using the dns module:

```hcl
module "dns_records" {
  source  = "../../modules/dns"
  zone_id = module.public_hosted_zone.zone_id

  records = {
    app = {
      name    = "app.example.com"
      type    = "CNAME"
      ttl     = 300
      records = [module.load_balancer.load_balancer_dns_name]
    }
  }
}
```
