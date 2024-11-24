data "aws_region" "current" {}

locals {
  region = coalesce(var.region, data.aws_region.current.name)
}

module "public_cluster" {
  source = "../modules/composite/public-cluster"

  region      = local.region
  subdomain   = var.subdomain
  domain_name = var.domain_name
  name        = var.name
  environment = var.environment

  tags = var.tags
}
