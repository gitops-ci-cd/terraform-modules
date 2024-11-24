variable "name" {
  description = "Name to use for various resources."
  type        = string
}

variable "region" {
  description = "AWS region."
  type        = string
}

variable "subdomain" {
  description = "The subdomain to use for the Load Balancer (e.g., www, api)"
  type        = string
  default     = "www"
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
