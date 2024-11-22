variable "domain_name" {
  description = "The domain name for the certificate."
  type        = string
}

variable "subject_alternative_names" {
  description = "Additional domain names for the certificate."
  type        = list(string)
  default     = []
}

variable "zone_id" {
  description = "The Route 53 hosted zone ID for DNS validation."
  type        = string
}

variable "ttl" {
  description = "The TTL for DNS validation records."
  type        = number
  default     = 300
}

variable "tags" {
  description = "Tags to apply to the ACM certificate."
  type        = map(string)
  default     = {}
}
