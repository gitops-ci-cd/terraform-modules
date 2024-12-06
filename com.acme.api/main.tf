module "public_cluster" {
  source = "../modules/composite/public-cluster"

  name        = var.name
  environment = var.environment

  tags = var.tags
}
