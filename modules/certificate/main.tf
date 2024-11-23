# Create ACM Certificate
resource "aws_acm_certificate" "certificate" {
  domain_name               = var.domain_name
  validation_method         = "DNS"
  subject_alternative_names = var.subject_alternative_names

  tags = var.tags
}

# DNS Validation Records
resource "aws_route53_record" "dns_validation" {
  for_each = {
    for idx, option in tolist(aws_acm_certificate.certificate.domain_validation_options) : idx => option
  }

  name    = each.value.resource_record_name
  type    = each.value.resource_record_type
  zone_id = var.zone_id
  records = [each.value.resource_record_value]
  ttl     = var.ttl
}

# Certificate Validation
resource "aws_acm_certificate_validation" "validation" {
  certificate_arn         = aws_acm_certificate.certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.dns_validation : record.fqdn]
}
