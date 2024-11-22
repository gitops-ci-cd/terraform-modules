# Load Balancer

Generic module for managing load balancers.

This module creates an AWS Load Balancer with support for Application Load Balancers (ALB) and Network Load Balancers (NLB). By default, it creates an ALB, but you can switch to an NLB by specifying the type variable.

## Usage

To use this module, include the following configuration in your Terraform setup:

Example 1: Application Load Balancer (Default)

```hcl
module "load_balancer" {
  source = "../../modules/load-balancer"

  name            = "my-alb"
  type            = "application" # ALB
  subnets         = ["subnet-12345678", "subnet-87654321"]
  security_groups = ["sg-12345678"]
  tags = {
    Environment = "production"
    Team        = "platform"
  }
}
```

Example 2: Network Load Balancer

```hcl
module "load_balancer" {
  source = "../../modules/load-balancer"

  name                       = "my-nlb"
  type                       = "network" # NLB
  subnets                    = ["subnet-12345678", "subnet-87654321"]
  internal                   = true
  enable_deletion_protection = true
  tags = {
    Environment = "staging"
    Team        = "networking"
  }
}
```

### Requirements

- Terraform Version: 0.12 or later.
- AWS Provider Plugin: Ensure you have configured the AWS provider in your Terraform setup.

### Features

1. Supports ALB and NLB
    - Defaults to creating an ALB (application type).
    - Easily switch to an NLB by setting type = "network".
1. Security and Flexibility
    - Supports internet-facing or internal configurations using the internal variable.
    - Allows attaching custom security groups (required for ALBs).
1. Tagging
    - Apply consistent tags across your resources for better management.
1. Deletion Protection
    - Optional deletion protection to prevent accidental resource removal.

## Considerations

- Ensure you specify security groups for ALBs using the security_groups variable.
- The module expects a list of subnet IDs for attaching the load balancer. For high availability, distribute these subnets across multiple availability zones (AZs).
- Use the load_balancer_dns_name output to route traffic to your load balancer (e.g., via Route 53).
- This module does not create listeners or target groups. You can manage those separately to route traffic to your backend services.
- Ensure that NLBs route traffic to the correct target type (e.g., IP or instance).

## Advanced Usage

Here’s an example of how you can use the load_balancer_dns_name output with a Route 53 record

```hcl
resource "aws_route53_record" "app_record" {
  zone_id = "Z3P5QSUBK4POTI"
  name    = "app.example.com"
  type    = "CNAME"
  ttl     = 300
  records = [module.load_balancer.load_balancer_dns_name]
}
```
