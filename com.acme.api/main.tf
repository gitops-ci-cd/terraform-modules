data "aws_region" "current" {}

locals {
  region = coalesce(var.region, data.aws_region.current.name)
}

module "public_cluster" {
  source = "../modules/composite/public-cluster"

  region      = local.region
  name        = var.name
  environment = var.environment

  tags = var.tags
}
