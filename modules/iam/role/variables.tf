variable "name" {
  description = "Name of the IAM role."
  type        = string
}

variable "assume_role_policy" {
  description = "Assume role policy document."
  type = object({
    Version = optional(string, "2012-10-17")
    Statement = list(object({
      Sid       = optional(string)
      Effect    = string
      Principal = map(string)
      Action    = list(string)
      Resource  = optional(list(string))
      Condition = optional(map(string))
    }))
  })
  validation {
    condition     = length(var.assume_role_policy.Statement) > 0
    error_message = "Assume role policy must have at least one statement."
  }
}

variable "tags" {
  description = "Tags to apply to the IAM role."
  type        = map(string)
  default     = {}
}
