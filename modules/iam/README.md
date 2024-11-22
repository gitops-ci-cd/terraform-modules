# IAM

Generic module for managing Identity and Access Management (IAM) resources.

This directory contains modules for managing AWS IAM resources in a modular and reusable way. The modules are designed to handle the creation and management of IAM roles, policies, and policy attachments. By breaking these functionalities into separate modules, you can manage IAM resources independently or combine them as needed for specific use cases.

## Modules Overview

1. Role Module
    - Purpose: Creates IAM roles with custom assume role policies.
    - Use Case: For defining roles that AWS services (e.g., EC2, Lambda) or users assume to perform specific tasks.
1. Policy Module
    - Purpose: Creates IAM policies with custom permissions.
    - Use Case: For defining granular access permissions to AWS resources.
1. Attachment Module
    - Purpose: Attaches IAM policies (custom or managed) to IAM roles.
    - Use Case: For linking roles to the required permissions via policy ARNs.

## Usage

### Create a Role

```hcl
module "example_role" {
  source = "../../modules/iam/role"

  name = "example-role"
  assume_role_policy = {
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { Service = "ec2.amazonaws.com" }
        Action    = "sts:AssumeRole"
      }
    ]
  }
  tags = {
    environment = "production"
  }
}
```

### Create a Policy

```hcl
module "example_policy" {
  source = "../../modules/iam/policy"

  name        = "example-policy"
  description = "Policy for accessing S3"
  policy = {
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:*"]
        Resource = ["*"]
      }
    ]
  }
  tags = {
    environment = "production"
  }
}
```

### Attach the Policy to the Role

```hcl
module "example_attachment" {
  source = "../../modules/iam/attachment"

  role_arn  = module.example_role.role_arn
  policy_arn = module.example_policy.policy_arn
}
```

### Benefits of Modular Design

1. Granular Resource Management
    - Each module focuses on a single responsibility (roles, policies, attachments), making it easier to manage and debug.
1. Reusability
    - The modules can be reused across projects or environments without modification.
1. Flexibility
    - IAM roles, policies, and attachments can be created and managed independently, providing greater flexibility in complex setups.
1. Scalability
    - Easily add or modify individual IAM components without impacting other parts of the infrastructure.

### Best Practices

1. Tags
    - Apply consistent tags to all IAM resources for better organization and cost tracking.
1. Granular Policies
    - Define narrowly scoped policies to follow the principle of least privilege.
1. Role Naming
    - Use descriptive and consistent role names to make it easier to identify their purpose.
1. Role and Policy Separation
    - Keep roles and policies modular. Roles define who can perform actions, and policies define what actions can be performed.
