variable "name" {
  description = "Name to use for various resources."
  type        = string
}

variable "region" {
  description = "AWS region."
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
