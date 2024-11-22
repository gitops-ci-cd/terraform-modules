variable "zone_id" {
  description = "The ID of the Route 53 hosted zone."
  type        = string
}

variable "records" {
  description = "A map of DNS records to create."
  type = map(object({
    name                   = string
    type                   = string # "A", "CNAME", "ALIAS", etc.
    ttl                    = optional(number, 300)
    records                = optional(list(string), [])
    alias_name             = optional(string, null)
    alias_zone_id          = optional(string, null)
    evaluate_target_health = optional(bool, false)
  }))
}
