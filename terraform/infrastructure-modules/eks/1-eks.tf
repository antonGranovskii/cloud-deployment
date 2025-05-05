resource "aws_iam_role" "eks" {
  name = "${var.eks_name}-eks-cluster"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "eks" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks.name
}

resource "aws_security_group" "worker" {
  name        = var.eks_name
  vpc_id      = var.vpc_id

  tags = merge(
    { Name = "${var.eks_name}-worker-sg" },
    var.eks_worker_sg_tags
  )
}

resource "aws_eks_cluster" "this" {
  name     = "${var.eks_name}"
  version  = var.eks_version
  role_arn = aws_iam_role.eks.arn

  vpc_config {
    endpoint_private_access = false
    endpoint_public_access  = true
    subnet_ids = var.subnet_ids
    security_group_ids = [
      aws_security_group.worker.id
    ]
  }

  depends_on = [aws_iam_role_policy_attachment.eks]
}

output "cluster_security_group_id" {
  description = "Security group ID of the EKS cluster control plane"
  value       = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
}