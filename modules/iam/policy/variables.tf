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
  type = object({
    Version   = optional(string, "2012-10-17")
    Statement = list(object({
      Sid       = optional(string)
      Effect    = string
      Action    = list(string)
      Resource  = optional(list(string))
      Condition = optional(map(string))
    }))
  })
  validation {
    condition     = length(var.policy.Statement) > 0
    error_message = "Policy must have at least one statement."
  }
}

variable "tags" {
  description = "Tags to apply to the IAM policy."
  type        = map(string)
  default     = {}
}
