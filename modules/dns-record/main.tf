resource "aws_route53_record" "main" {
  for_each = var.records

  zone_id = var.zone_id
  name    = each.value.name
  type    = each.value.type

  # Include ttl only for non-alias records
  ttl = contains(keys(each.value), "alias_name") && each.value.alias_name != null ? null : each.value.ttl

  # Dynamically include alias block only if all alias fields are provided
  dynamic "alias" {
    for_each = contains(keys(each.value), "alias_name") && each.value.alias_name != null && each.value.alias_zone_id != null ? [each.value] : []
    content {
      name                   = alias.value.alias_name
      zone_id                = alias.value.alias_zone_id
      evaluate_target_health = alias.value.evaluate_target_health
    }
  }
}
