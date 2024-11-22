variable "name" {
  description = "Name to use for various resources."
  type        = string
}

variable "region" {
  description = "AWS region."
  type        = string
}

variable "domain_name" {
  description = "Domain name to expose the cluster (e.g., api.acme.inc)."
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, production)."
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources."
  type        = map(string)
}
