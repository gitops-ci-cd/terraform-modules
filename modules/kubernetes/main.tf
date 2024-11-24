locals {
  private_subnets = data.aws_subnets.private.ids
}

# Cluster IAM
module "cluster_role" {
  source = "../iam/role"

  name = "${var.cluster_name}-k8s-cluster-role"
  assume_role_policy = {
    Statement = [
      {
        Effect    = "Allow"
        Principal = { Service = "eks.amazonaws.com" }
        Action    = ["sts:AssumeRole"]
      }
    ]
  }

  tags = var.tags
}
module "cluster_policy" {
  source = "../iam/policy"

  name        = "${var.cluster_name}-k8s-cluster-policy"
  description = "Policy for EKS cluster to manage associated resources"
  policy = {
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["ec2:Describe*", "ecr:GetAuthorizationToken", "autoscaling:Describe*"]
        Resource = ["*"]
      }
    ]
  }

  tags = var.tags
}
module "cluster_policy_attachment" {
  source = "../iam/attachment"

  role_arn   = module.cluster_role.role_arn
  policy_arn = module.cluster_policy.policy_arn
}

# Create the EKS Cluster
resource "aws_eks_cluster" "main" {
  name     = var.cluster_name
  role_arn = module.cluster_role.role_arn

  vpc_config {
    subnet_ids         = local.private_subnets
    security_group_ids = var.security_groups
  }

  version = var.kubernetes_version

  tags = var.tags
}

# Create Node Groups
resource "aws_eks_node_group" "main" {
  for_each = { for ng in var.node_groups : ng.name => ng }

  cluster_name    = aws_eks_cluster.main.name
  node_group_name = each.value.name
  node_role_arn   = each.value.node_role_arn

  scaling_config {
    desired_size = each.value.desired_size
    min_size     = each.value.min_size
    max_size     = each.value.max_size
  }

  instance_types = [each.value.instance_type]
  subnet_ids     = var.subnet_ids

  tags = var.tags
}
