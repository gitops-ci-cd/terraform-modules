variable "cluster_name" {
  description = "The name of the EKS cluster."
  type        = string
}

variable "region" {
  description = "The AWS region to deploy the EKS cluster."
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID where the EKS cluster will be deployed."
  type        = string
}

variable "subnet_ids" {
  description = "A list of subnet IDs for the EKS cluster."
  type        = list(string)
}

variable "kubernetes_version" {
  description = "The Kubernetes version for the EKS cluster."
  type        = string
  default     = "1.27"
}

variable "node_groups" {
  description = "List of configurations for EKS node groups."
  type = list(object({
    name              = string
    desired_size      = number
    min_size          = number
    max_size          = number
    instance_type     = string
    node_role_arn     = string
  }))
  default = []
}

variable "tags" {
  description = "A map of tags to assign to resources."
  type        = map(string)
  default     = {}
}
