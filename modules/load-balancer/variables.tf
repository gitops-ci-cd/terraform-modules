variable "name" {
  description = "Name of the load balancer."
  type        = string
}

variable "type" {
  description = "Type of the load balancer: application (ALB) or network (NLB)."
  type        = string
  default     = "application" # Default is ALB
  validation {
    condition     = contains(["application", "network"], var.type)
    error_message = "Type must be 'application' (ALB) or 'network' (NLB)."
  }
}

variable "subnets" {
  description = "List of subnet IDs to attach the load balancer to."
  type        = list(string)
}

variable "security_groups" {
  description = "List of security group IDs to associate with the load balancer. Required for ALBs."
  type        = list(string)
  default     = []
}

variable "internal" {
  description = "Whether the load balancer is internal. Default is false (internet-facing)."
  type        = bool
  default     = false
}

variable "enable_deletion_protection" {
  description = "Whether to enable deletion protection on the load balancer."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to apply to the load balancer."
  type        = map(string)
  default     = {}
}
