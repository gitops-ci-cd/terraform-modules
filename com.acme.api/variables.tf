variable "name" {
  description = "Name to use for various resources."
  default     = "acme"
}

variable "region" {
  description = "AWS region."
  type        = string
  default     = null
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, production)."
  default     = "production"
}

variable "tags" {
  description = "Tags to apply to all resources."
  default = {
    Project   = "gitops-ci-cd"
    ManagedBy = "Terraform"
    Team      = "platform"
  }
}
