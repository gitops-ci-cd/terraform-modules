output "cluster_id" {
  description = "The ID of the EKS cluster."
  value       = aws_eks_cluster.main.id
}

output "cluster_endpoint" {
  description = "The endpoint for the Kubernetes API server."
  value       = aws_eks_cluster.main.endpoint
}

output "cluster_arn" {
  description = "The ARN of the EKS cluster."
  value       = aws_eks_cluster.main.arn
}

output "node_group_arns" {
  description = "The ARNs of the EKS node groups."
  value       = aws_eks_node_group.default.*.arn
}

output "node_group_names" {
  description = "The names of the EKS node groups."
  value       = aws_eks_node_group.default.*.node_group_name
}
