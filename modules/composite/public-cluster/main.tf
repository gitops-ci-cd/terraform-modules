locals {
  tags = merge(
    {
      Name        = var.name
      Environment = var.environment
    },
    var.tags
  )
}

# VPC
module "vpc" {
  source = "../../vpc"

  tags = local.tags
}

# Node IAM
module "node_role" {
  source = "../../iam/role"

  name = "${var.name}-${var.environment}-k8s-node"
  assume_role_policy = {
    Statement = [
      {
        Effect    = "Allow"
        Principal = { Service = "ec2.amazonaws.com" }
        Action    = ["sts:AssumeRole"]
      }
    ]
  }

  tags = local.tags
}
module "node_policy" {
  source = "../../iam/policy"

  name        = "${var.name}-${var.environment}-k8s-node"
  description = "Policy for EKS worker nodes to access S3 and CloudWatch"
  policy = {
    Statement = [
      {
        Effect   = "Allow"
        Resource = ["*"]
        Action   = ["s3:*", "ec2:Describe*", "logs:*", "cloudwatch:*"]
      }
    ]
  }

  tags = local.tags
}
module "node_policy_attachment" {
  source = "../../iam/attachment"

  role_arn   = module.node_role.role_arn
  policy_arn = module.node_policy.policy_arn
}

# Kubernetes Cluster
module "cluster_security_group" {
  source = "../../security-group"

  name        = "${var.name}-${var.environment}-k8s-cluster"
  description = "EKS security group for worker nodes"
  vpc_id      = module.vpc.vpc_id

  ingress_rules = [{
    description = "Allow traffic from the load balancer"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
  }]

  egress_rules = [{
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }]

  tags = local.tags
}
resource "aws_security_group_rule" "node_to_node" {
  description              = "Allow Kubernetes nodes to communicate with each other"
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "-1"
  self                     = true
  security_group_id        = module.cluster_security_group.security_group_id
  source_security_group_id = module.cluster_security_group.security_group_id
}
module "kubernetes" {
  source = "../../kubernetes"

  cluster_name    = "${var.name}-${var.environment}-cluster"
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnets
  security_groups = [module.cluster_security_group.security_group_id]

  # Node group details
  node_groups = [
    {
      name          = "${var.name}-${var.environment}-node-group"
      desired_size  = 2
      max_size      = 5
      min_size      = 1
      node_role_arn = module.node_role.role_arn
      instance_type = "t3.medium"
    }
  ]

  tags = local.tags
}
