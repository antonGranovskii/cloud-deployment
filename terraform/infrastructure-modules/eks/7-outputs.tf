output "eks_name" {
  description = "The name of the Amazon EKS cluster."
  value       = aws_eks_cluster.this.name
}

output "eks_endpoint" {
  description = "The endpoint for the Kubernetes API server of the EKS cluster."
  value       = aws_eks_cluster.this.endpoint
}

output "eks_ca_certificate" {
  description = "The base64-encoded certificate data required to communicate with the Kubernetes cluster."
  value       = aws_eks_cluster.this.certificate_authority[0].data
}

output "eks_id" {
  description = "The unique ID of the EKS cluster."
  value       = aws_eks_cluster.this.id
}

output "aws_iam_openid_connect_provider_arn" {
  description = "The ARN of the IAM OIDC provider associated with the EKS cluster for IAM roles for service accounts (IRSA)."
  value       = aws_iam_openid_connect_provider.this[0].arn
}

output "aws_iam_openid_connect_provider_url" {
  description = "The URL of the IAM OIDC provider used by the EKS cluster for IRSA."
  value       = aws_iam_openid_connect_provider.this[0].url
}

output "aws_iam_role_nodes_name" {
  description = "The name of the IAM role assigned to EKS worker nodes."
  value       = aws_iam_role.nodes.name
}
