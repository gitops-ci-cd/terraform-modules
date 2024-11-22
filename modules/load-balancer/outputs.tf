output "load_balancer_arn" {
  description = "The ARN of the load balancer."
  value       = aws_lb.load_balancer.arn
}

output "load_balancer_dns_name" {
  description = "The DNS name of the load balancer."
  value       = aws_lb.load_balancer.dns_name
}

output "load_balancer_zone_id" {
  description = "The zone ID of the load balancer."
  value       = aws_lb.load_balancer.zone_id
}
