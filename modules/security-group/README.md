# Security Group

Generic module for managing security groups.

Concretely, this Terraform module creates an AWS security group with customizable ingress and egress rules. The module allows for defining multiple rules dynamically and supports both IPv4 and IPv6 configurations.

## Usage

Here is an example of how to use the security-group module:

```hcl
module "cluster_security_group" {
  source = "../../modules/security-group"

  name        = "k8s-cluster-sg"
  description = "Security group for Kubernetes cluster"
  vpc_id      = module.vpc.vpc_id

  ingress_rules = [
    {
      description      = "Allow HTTPS traffic"
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
    },
    {
      description      = "Allow HTTP traffic"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
    }
  ]

  egress_rules = [
    {
      description      = "Allow all outbound traffic"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
    }
  ]

  tags = {
    Environment = "production"
    Team        = "devops"
  }
}
```

## Considerations

1. Rule Validation
    - Ensure you provide valid port ranges, protocols, and CIDR blocks.
    - Use -1 for protocol when defining “all” traffic.
1. Ingress/Egress Rules
    - Leave ingress_rules and egress_rules empty to create a security group with no rules.
