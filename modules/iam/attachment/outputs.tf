output "attachment" {
  description = "The IAM role and policy attachment details."
  value = {
    role       = var.role_arn
    policy_arn = var.policy_arn
  }
}
