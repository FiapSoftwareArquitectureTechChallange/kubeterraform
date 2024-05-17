output "ecr_repository_url" {
  value = aws_ecr_repository.ecr_repository.repository_url
}

output "cluster_security_group_id" {
  description = "Security group IDs attached to the EKS cluster."
  value       = aws_eks_cluster.burgercluster.vpc_config[0].security_group_ids
}

output "cluster_endpoint" {
  description = "The endpoint for your EKS Kubernetes API."
  value       = aws_eks_cluster.burgercluster.endpoint
}

output "cluster_certificate_authority_data" {
  description = "The certificate authority data for your EKS cluster."
  value       = aws_eks_cluster.burgercluster.certificate_authority[0].data
}

output "cluster_id" {
  description = "The ID of the EKS cluster."
  value       = aws_eks_cluster.burgercluster.id
}

output "cluster_name" {
  description = "Cluster name"
  value       = aws_eks_cluster.burgercluster.name
}

output "kubeconfig_command" {
  value = "aws eks update-kubeconfig --region ${var.aws_region} --name ${aws_eks_cluster.burgercluster.name}"
}

output "matching_security_groups" {
  value = data.aws_security_group.secgroup
}
