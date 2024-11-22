module "public_cluster" {
  source = "../modules/composite/public-cluster"

  region         = var.region
  domain_name    = var.domain_name
  name           = var.name
  environment    = var.environment

  tags = var.tags
}
