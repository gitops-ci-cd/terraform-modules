locals {
  tags = merge(var.tags, { Environment = var.environment })
}

# Hosted Zone
module "hosted_zone" {
  source      = "../../hosted-zone"

  domain_name = var.domain_name

  tags = locals.tags
}

# DNS Record
module "dns_record" {
  source = "../../dns-record"

  zone_id = module.hosted_zone.zone_id
  records = {
    www = {
      name                   = "www.${var.domain_name}"
      type                   = "A"
      ttl                    = 300
      alias_name             = module.load_balancer.lb_dns_name
      alias_zone_id          = module.load_balancer.lb_zone_id
      evaluate_target_health = true
    }
  }
}

# Certificate
module "acm" {
  source           = "../../certificate"

  domain_name      = var.domain_name
  validation_method = "DNS"
  route53_zone_id   = module.hosted_zone.zone_id

  tags = locals.tags
}

# VPC
module "vpc" {
  source = "../../vpc"

  vpc_name = "${var.name}-vpc"

  tags = locals.tags
}

# Load Balancer
module "load_balancer" {
  source  = "../../load-balancer"

  name     = "${var.environment}-lb"
  subnets  = module.vpc.public_subnet_ids
  type     = "application"
  internal = false

  tags = locals.tags
}

# Cluster IAM
module "cluster_role" {
  source = "../../iam/role"

  name = "k8s-cluster-role"
  assume_role_policy = {
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { Service = "eks.amazonaws.com" }
        Action    = "sts:AssumeRole"
      }
    ]
  }

  tags = locals.tags
}
module "cluster_policy" {
  source = "../../iam/policy"

  name        = "k8s-cluster-policy"
  description = "Policy for EKS cluster to manage associated resources"
  policy = {
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["ec2:Describe*", "ecr:GetAuthorizationToken", "autoscaling:Describe*"]
        Resource = "*"
      }
    ]
  }

  tags = locals.tags
}
module "cluster_policy_attachment" {
  source = "../../iam/attachment"

  role_arn  = module.cluster_role.role_arn
  policy_arn = module.cluster_policy.policy_arn
}

# Node IAM
module "node_role" {
  source = "../../iam/role"

  name = "k8s-node-role"
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

  tags = locals.tags
}
module "node_policy" {
  source = "../../iam/policy"

  name        = "k8s-node-policy"
  description = "Policy for EKS worker nodes to access S3 and CloudWatch"
  policy = {
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:*", "ec2:Describe*", "logs:*", "cloudwatch:*"]
        Resource = "*"
      }
    ]
  }

  tags = locals.tags
}
module "node_policy_attachment" {
  source = "../../iam/attachment"

  role_arn  = module.node_role.role_arn
  policy_arn = module.node_policy.policy_arn
}

# K8s Cluster
module "kubernetes" {
  source = "../../kubernetes"

  cluster_name       = "${var.environment}-cluster"
  region             = var.region
  vpc_id             = module.vpc.vpc_id
  subnet_ids         = module.vpc.private_subnet_ids

  tags = locals.tags
}
