output "load_balancer_arn" {
  description = "The ARN of the load balancer."
  value       = aws_lb.main.arn
}

output "load_balancer_dns_name" {
  description = "The DNS name of the load balancer."
  value       = aws_lb.main.dns_name
}

output "load_balancer_zone_id" {
  description = "The zone ID of the load balancer."
  value       = aws_lb.main.zone_id
}
