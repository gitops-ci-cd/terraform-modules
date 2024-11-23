locals {
  tags = merge(var.tags, { Environment = var.environment })
}

# Hosted Zone
module "hosted_zone" {
  source      = "../../hosted-zone"

  domain_name = var.domain_name

  tags = local.tags
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
      alias_name             = module.load_balancer.load_balancer_dns_name
      alias_zone_id          = module.load_balancer.load_balancer_zone_id
      evaluate_target_health = true
    }
  }
}

# Certificate
module "acm" {
  source           = "../../certificate"

  domain_name      = var.domain_name
  zone_id   = module.hosted_zone.zone_id

  tags = local.tags
}

# VPC
module "vpc" {
  source = "../../vpc"

  vpc_name = "${var.name}-vpc"

  tags = local.tags
}

# Load Balancer
module "load_balancer" {
  source  = "../../load-balancer"

  name     = "${var.name}-${var.environment}-lb"
  subnets  = module.vpc.public_subnet_ids
  type     = "application"
  internal = false

  tags = local.tags
}

# Node IAM
module "node_role" {
  source = "../../iam/role"

  name = "${var.name}-k8s-node-role"
  assume_role_policy = {
    Statement = [
      {
        Effect    = "Allow"
        Principal = { Service = "ec2.amazonaws.com" }
        Action    = [ "sts:AssumeRole" ]
      }
    ]
  }

  tags = local.tags
}
module "node_policy" {
  source = "../../iam/policy"

  name        = "${var.name}-k8s-node-policy"
  description = "Policy for EKS worker nodes to access S3 and CloudWatch"
  policy = {
    Statement = [
      {
        Effect   = "Allow"
        Resource = [ "*" ]
        Action   = [ "s3:*", "ec2:Describe*", "logs:*", "cloudwatch:*" ]
      }
    ]
  }

  tags = local.tags
}
module "node_policy_attachment" {
  source = "../../iam/attachment"

  role_arn  = module.node_role.role_arn
  policy_arn = module.node_policy.policy_arn
}

# K8s Cluster
module "kubernetes" {
  source = "../../kubernetes"

  cluster_name       = "${var.name}-${var.environment}-cluster"
  region             = var.region
  vpc_id             = module.vpc.vpc_id
  subnet_ids         = module.vpc.private_subnet_ids

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
