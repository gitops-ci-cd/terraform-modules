output "vpc_id" {
  description = "The ID of the VPC."
  value       = module.vpc.vpc_id
}

output "cluster_id" {
  description = "The ID of the Kubernetes cluster."
  value       = module.kubernetes.cluster_id
}
