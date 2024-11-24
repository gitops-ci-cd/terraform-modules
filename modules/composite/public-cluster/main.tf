locals {
  tags = merge(
    {
      Name        = var.name
      Environment = var.environment
    },
    var.tags
  )
}

# Hosted Zone
module "hosted_zone" {
  source = "../../hosted-zone"

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
  source = "../../certificate"

  domain_name = var.domain_name
  zone_id     = module.hosted_zone.zone_id

  tags = local.tags
}

# VPC
module "vpc" {
  source = "../../vpc"

  vpc_name = "${var.name}-vpc"

  tags = local.tags
}

# Application Load Balancer
module "load_balancer_security_group" {
  source = "../../security-group"

  name        = "${var.name}-lb-sg"
  description = "Default security group for the load balancer"
  vpc_id      = module.vpc.vpc_id

  ingress_rules = [{
    description = "Allow HTTP traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }, {
    description = "Allow HTTPS traffic"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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
module "load_balancer" {
  source = "../../load-balancer"

  name            = "${var.name}-${var.environment}-lb"
  security_groups = [module.load_balancer_security_group.security_group_id]
  subnets         = module.vpc.public_subnets

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
        Action    = ["sts:AssumeRole"]
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

  name        = "${var.name}-eks-sg"
  description = "EKS security group for worker nodes"
  vpc_id      = module.vpc.vpc_id

  ingress_rules = [{
    description     = "Allow traffic from the load balancer"
    from_port       = 0
    to_port         = 65535
    protocol        = "tcp"
    security_groups = [module.load_balancer_security_group.security_group_id]
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
  protocol                 = "tcp"
  security_group_id        = module.cluster_security_group.security_group_id
  source_security_group_id = module.cluster_security_group.security_group_id
}
module "kubernetes" {
  source = "../../kubernetes"

  cluster_name    = "${var.name}-${var.environment}-cluster"
  region          = var.region
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
