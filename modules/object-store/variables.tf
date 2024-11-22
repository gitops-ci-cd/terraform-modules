variable "bucket_name" {
  description = "Name of the Storage bucket"
  type        = string
}

variable "tags" {
  description = "A mapping of tags to assign to the bucket"
  type        = map(string)
  default     = {}
}
