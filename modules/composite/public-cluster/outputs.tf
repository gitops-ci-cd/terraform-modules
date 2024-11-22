output "vpc_id" {
  description = "The ID of the VPC."
  value       = module.vpc.vpc_id
}

output "cluster_name" {
  description = "The name of the Kubernetes cluster."
  value       = module.kubernetes.cluster_name
}

output "load_balancer_dns_name" {
  description = "The DNS name of the load balancer."
  value       = module.load_balancer.lb_dns_name
}

output "domain_name" {
  description = "The domain name pointing to the cluster."
  value       = var.domain_name
}
