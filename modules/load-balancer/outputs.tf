output "load_balancer_arn" {
  description = "The ARN of the load balancer."
  value       = aws_lb.main.arn
}
