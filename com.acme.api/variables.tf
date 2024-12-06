variable "name" {
  description = "Name to use for various resources."
  type        = string
  default     = "acme"
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, production)."
  type        = string
  default     = "production"
}

variable "tags" {
  description = "Tags to apply to all resources."
  type        = map(string)
  default = {
    Project   = "gitops-ci-cd"
    ManagedBy = "Terraform"
    Team      = "platform"
  }
}
