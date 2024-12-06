variable "name" {
  description = "Name to use for various resources."
  type        = string
  default     = "acme.com"
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
