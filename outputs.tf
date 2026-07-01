output "cluster_endpoint" {
  value       = aws_eks_cluster.eks_cluster.endpoint
  description = "The endpoint URL for the EKS control plane"
}

output "cluster_name" {
  value       = aws_eks_cluster.eks_cluster.name
  description = "The name of the EKS cluster"
}

output "cluster_arn" {
  value       = aws_eks_cluster.eks_cluster.arn
  description = "The ARN of the EKS cluster"
}

output "cluster_certificate_authority_data" {
  value       = aws_eks_cluster.eks_cluster.certificate_authority[0].data
  description = "The certificate authority data for the EKS cluster"
}

output "node_group_arn" {
  value       = aws_eks_node_group.eks_nodes.arn
  description = "The ARN of the EKS node group"
}

output "node_group_id" {
  value       = aws_eks_node_group.eks_nodes.id
  description = "The ID of the EKS node group"
}

output "subnet_ids" {
  value       = aws_subnet.eks_subnet[*].id
  description = "The IDs of the subnets created for the EKS cluster"
}

output "vpc_id" {
  value       = aws_vpc.eks_vpc.id
  description = "The ID of the VPC created for the EKS cluster"
}
