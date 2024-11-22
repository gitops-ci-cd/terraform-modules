# Kubernetes

Generic module for managing Kubernetes clusters.

This module provides an abstraction for creating and managing AWS EKS clusters. The module is designed to simplify cluster management while ensuring Kubernetes-native compatibility.

## Usage

To create and manage an EKS cluster using this module, include a manifest like the following:

```hcl
module "eks_cluster" {
  source = "../../modules/kubernetes"

  cluster_name         = "my-eks-cluster"
  region               = "us-west-2"
  kubernetes_version   = "1.27"
  vpc_id               = "vpc-0abcdef1234567890"
  subnet_ids           = ["subnet-0123456789abcdef0", "subnet-abcdef0123456789"]
  tags = {
    environment = "production"
    team        = "platform"
  }
  node_group = {
    name           = "default-node-group"
    instance_type  = "t3.medium"
    desired_size   = 3
    min_size       = 1
    max_size       = 6
  }
}
```

### Requirements

- Terraform 0.12.x and above
- AWS Provider plugin

Ensure your AWS credentials and permissions are configured correctly, either through IRSA or AWS access credentials.

## Considerations

- Ensure that the AWS IAM roles and policies have sufficient permissions to create and manage EKS clusters, node groups, and associated resources.
- The Kubernetes version specified in the version field must be supported by AWS for EKS clusters. Check the EKS documentation for available versions.
- Configure IRSA for secure and scalable integration between Kubernetes and AWS services.
