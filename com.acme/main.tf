module "hosted_zone" {
  source = "../modules/hosted-zone"

  domain_name = var.name

  tags = var.tags
}
