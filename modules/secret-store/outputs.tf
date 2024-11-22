output "all_secret_values" {
  value     = data.vault_kv_secret_v2.demo
  sensitive = true
}

output "buckets" {
  value = data.vault_kv_secret_v2.buckets
}
