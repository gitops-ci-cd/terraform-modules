# DNS Record

Generic module for managing domain name system (DNS) records.

This module manages DNS records in AWS Route 53, supporting multiple record types like A, CNAME, and ALIAS. It is designed to work with outputs from other modules (e.g., load-balancer) for seamless integration.

## Usage

Example 1: Simple CNAME Record

Create a CNAME record pointing to an ALB’s DNS name:

```hcl
module "dns" {
  source  = "../../modules/dns-record"
  zone_id = "Z3P5QSUBK4POTI"

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

Example 2: Alias Record for NLB

Create an A record using Route 53 alias functionality for an NLB:

```hcl
module "dns" {
  source  = "../../modules/dns-record"
  zone_id = "Z3P5QSUBK4POTI"

  records = {
    api = {
      name                   = "api.example.com"
      type                   = "A"
      alias_name             = module.load_balancer.load_balancer_dns_name
      alias_zone_id          = module.load_balancer.load_balancer_zone_id
      evaluate_target_health = true
    }
  }
}
```

Example 3: Multiple DNS Records

Create multiple DNS records in a single module:

```hcl
module "dns" {
  source  = "../../modules/dns-record"
  zone_id = "Z3P5QSUBK4POTI"

  records = {
    app = {
      name    = "app.example.com"
      type    = "CNAME"
      ttl     = 300
      records = [module.load_balancer.load_balancer_dns_name]
    },
    api = {
      name                   = "api.example.com"
      type                   = "A"
      alias_name             = module.load_balancer.load_balancer_dns_name
      alias_zone_id          = module.load_balancer.load_balancer_zone_id
      evaluate_target_health = true
    }
  }
}
```

### Requirements

- Terraform Version: 0.12 or later.
- AWS Provider Plugin: Ensure you have configured the AWS provider in your Terraform setup.
- Route 53 Hosted Zone: A hosted zone must already exist in Route 53.

### Features

1. Flexible Record Types
    - Supports A, CNAME, ALIAS, and other DNS record types.
    - Automatically configures Route 53 alias records for ALBs and NLBs.
1. Dynamic Inputs
    - Works seamlessly with outputs from other modules (e.g., load-balancer).
1. Reusable Across Environments
    - Easily create DNS records for staging, production, or other environments.
1. Customizable
    - Fully supports TTL customization, target health evaluation, and advanced configurations.

### Example Output

After applying the module, you can access the details of created DNS records:

```hcl
output "dns_records" {
  value = module.dns.dns_records
}

# {
#   app = {
#     fqdn    = "app.example.com"
#     type    = "CNAME"
#     ttl     = 300
#     records = ["my-alb-123456.us-east-1.elb.amazonaws.com"]
#   },
#   api = {
#     fqdn    = "api.example.com"
#     type    = "A"
#     ttl     = null
#     records = []
#   }
# }
```

## Additional Notes

- Hosted Zone Management:
- This module does not create hosted zones. You should manage hosted zones separately or use another module for that purpose.
- Integration with Load Balancers:
- Use this module in conjunction with the load-balancer module to dynamically create DNS records for ALBs or NLBs.
