variable "domain_name" {
  description = "The domain name for the certificate."
  type        = string
}

variable "subject_alternative_names" {
  description = "Additional domain names for the certificate."
  type        = list(string)
  default     = []
}

variable "validation_method" {
  description = "Method for validating the certificate (DNS or EMAIL)."
  type        = string
  default     = "DNS"
}

variable "route53_zone_id" {
  description = "The Route 53 hosted zone ID for DNS validation. Required if validation_method is DNS."
  type        = string
  default     = ""
}

variable "dns_validation_ttl" {
  description = "The TTL for DNS validation records."
  type        = number
  default     = 300
}

variable "tags" {
  description = "Tags to apply to the ACM certificate."
  type        = map(string)
  default     = {}
}
