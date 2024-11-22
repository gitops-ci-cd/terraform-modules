output "dns_records" {
  description = "Details of the created DNS records."
  value = {
    for k, r in aws_route53_record.dns_record :
    k => {
      fqdn    = r.fqdn
      type    = r.type
      ttl     = r.ttl
      records = r.records
    }
  }
}