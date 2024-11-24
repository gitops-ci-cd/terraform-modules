variable "cidr_block" {
  description = "Optional CIDR block for the VPC. If not provided, one will be inferred."
  type        = string
  default     = null
}

variable "public_subnet_count" {
  description = "Number of public subnets to create."
  type        = number
  default     = 2
}

variable "private_subnet_count" {
  description = "Number of private subnets to create."
  type        = number
  default     = 2
}

variable "enable_nat_gateway" {
  description = "Whether to create a NAT Gateway for private subnets."
  type        = bool
  default     = true
}

variable "enable_internet_gateway" {
  description = "Whether to create an Internet Gateway for the VPC."
  type        = bool
  default     = true

}

variable "tags" {
  description = "Tags to assign to all resources."
  type        = map(string)
  default     = {}
}
