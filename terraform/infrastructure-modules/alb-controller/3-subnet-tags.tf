resource "aws_ec2_tag" "tag_public_subnets" {
  for_each = var.public_subnet_ids

  resource_id = each.value
  key         = "kubernetes.io/role/elb"
  value       = "1"
}

resource "aws_ec2_tag" "tag_private_subnets" {
  for_each = var.private_subnet_ids

  resource_id = each.value
  key         = "kubernetes.io/role/internal-elb"
  value       = "1"
}

resource "aws_ec2_tag" "tag_private_public_subnets" {
  for_each = var.private_public_subnet_ids

  resource_id = each.value
  key         = "kubernetes.io/cluster/${var.eks_id}"
  value       = "owned"
}
