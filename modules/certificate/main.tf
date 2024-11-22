# Create ACM Certificate
resource "aws_acm_certificate" "certificate" {
  domain_name       = var.domain_name
  validation_method = var.validation_method

  subject_alternative_names = var.subject_alternative_names

  tags = var.tags
}

# DNS Validation Records (Optional)
resource "aws_route53_record" "dns_validation" {
  count = var.validation_method == "DNS" ? length(aws_acm_certificate.certificate.domain_validation_options) : 0

  name    = aws_acm_certificate.certificate.domain_validation_options[count.index].resource_record_name
  type    = aws_acm_certificate.certificate.domain_validation_options[count.index].resource_record_type
  zone_id = var.route53_zone_id
  records = [aws_acm_certificate.certificate.domain_validation_options[count.index].resource_record_value]
  ttl     = var.dns_validation_ttl
}

# Certificate Validation
resource "aws_acm_certificate_validation" "validation" {
  certificate_arn         = aws_acm_certificate.certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.dns_validation : record.fqdn]
}
