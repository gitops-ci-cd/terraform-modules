variable "region" {
  description = "AWS region."
  type        = string
  default     = null
}

variable "name" {
  description = "Name to use for various resources."
  default     = "acme"
}

variable "subdomain" {
  description = "The subdomain to use for the Load Balancer (e.g., www, api)"
  type        = string
  default     = "api"
}

variable "domain_name" {
  description = "The domain name that will ultimately route to these resources."
  default     = "acme.com"
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
