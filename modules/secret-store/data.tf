data "vault_kv_secret_v2" "demo" {
  name = "terraform-demo"
  mount = var.secrets_path
}

data "vault_kv_secret_v2" "buckets" {
  name = "s3-buckets"
  mount = var.secrets_path
}
