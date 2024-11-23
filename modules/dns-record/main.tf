resource "aws_route53_record" "dns_record" {
  for_each = var.records

  zone_id = var.zone_id
  name    = each.value.name
  type    = each.value.type

  # Conditionally set ttl only if the record is not an alias
  ttl = each.value.alias_name != null ? null : each.value.ttl

  # Alias configuration
  alias {
    name                   = each.value.alias_name
    zone_id                = each.value.alias_zone_id
    evaluate_target_health = each.value.evaluate_target_health
  }
}
