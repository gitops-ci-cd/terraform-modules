output "certificate_arn" {
  description = "The ARN of the ACM certificate."
  value       = aws_acm_certificate.certificate.arn
}

output "validation_status" {
  description = "The status of the ACM certificate validation."
  value       = aws_acm_certificate.certificate.status
}

output "dns_validation_records" {
  description = "DNS validation records (if applicable)."
  value = [
    for record in aws_route53_record.dns_validation : {
      fqdn  = record.name
      type  = record.type
      value = tolist(record.records)[0]
    }
  ]
}
