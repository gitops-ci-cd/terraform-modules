variable "name" {
  description = "Name to use for various resources."
  default     = "acme.com"
}

variable "tags" {
  description = "Tags to apply to all resources."
  default = {
    Project   = "gitops-ci-cd"
    ManagedBy = "Terraform"
    Team      = "platform"
  }
}
