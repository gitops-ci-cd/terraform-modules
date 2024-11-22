variable "name" {
  description = "Name of the IAM role."
  type        = string
}

variable "assume_role_policy" {
  description = "Assume role policy document."
  type        = map(any)
}

variable "tags" {
  description = "Tags to apply to the IAM role."
  type        = map(string)
  default     = {}
}
