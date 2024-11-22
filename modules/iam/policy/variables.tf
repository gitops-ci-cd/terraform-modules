variable "name" {
  description = "Name of the IAM policy."
  type        = string
}

variable "description" {
  description = "Description of the IAM policy."
  type        = string
}

variable "policy" {
  description = "Policy document."
  type        = map(any)
}

variable "tags" {
  description = "Tags to apply to the IAM policy."
  type        = map(string)
  default     = {}
}
