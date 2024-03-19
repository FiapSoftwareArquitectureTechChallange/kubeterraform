# output "vpc_id" {
#   value = module.vpc.vpc_id
# }

# output "private_subnets" {
#   value = module.vpc.private_subnets
# }

# output "public_subnets" {
#   value = module.vpc.public_subnets
# }


output "ecr_repository_url" {
  value = aws_ecr_repository.ecr_repository.repository_url
}


output "cluster_security_group_id" {
  description = "Security group IDs attached to the EKS cluster."
  value       = module.eks.cluster_security_group_id
}


output "cluster_endpoint" {
  description = "The endpoint for your EKS Kubernetes API."
  value       = module.eks.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  description = "The certificate authority data for your EKS cluster."
  value       = module.eks.cluster_certificate_authority_data
}

output "cluster_id" {
  description = "The ID of the EKS cluster."
  value       = module.eks.cluster_id
}

output "cluster_name" {
  description = "Cluster name"
  value       = module.eks.cluster_name
}


output "kubeconfig_command" {
  description = "Command to update kubeconfig with your EKS cluster. This output will be empty if the cluster is not yet created."
  value       = try("aws eks update-kubeconfig --region ${var.aws_region} --name ${module.eks.cluster_id}", "")
}
