output "zone_id" {
  description = "The ID of the hosted zone."
  value       = aws_route53_zone.hosted_zone.id
}
