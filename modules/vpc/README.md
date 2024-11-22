# VPC

Generic module for managing Virtual Private Clouds (VPCs).

This module provides an abstraction for creating and managing AWS VPCs. The module is designed to simplify VPC management while ensuring flexibility for a wide range of use cases.

## Usage

To create and manage a VPC using this module, include the following configuration:

```hcl
module "vpc" {
  source = "../../modules/vpc"

  vpc_name             = "my-vpc"
  enable_nat           = true

  tags = {
    environment        = "production"
    team               = "platform"
  }
}
```

### Requirements

- Terraform 0.12.x and above
- AWS Provider plugin

### Features

- Public and Private Subnets: Supports creation of public and private subnets based on CIDR blocks.
- NAT Gateway: Optional NAT Gateway setup for routing private subnet traffic to the internet.
- Custom Tags: Apply consistent tags across all resources for easier management and cost allocation.
- Scalable Design: Designed to support large-scale infrastructure with customizable CIDR blocks and subnets.

## Considerations

- CIDR Block Allocation: Ensure that the provided CIDR block does not overlap with existing VPCs in your account or region.
- NAT Gateway Costs: Enabling a NAT Gateway incurs additional costs. For more details, refer to the AWS NAT Gateway Pricing.
- Subnets and Route Tables: The module automatically associates route tables with the created subnets. Public subnets are configured with an internet gateway.
