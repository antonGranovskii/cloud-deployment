output "vpc_id" {
    description = "EKS VPC ID."
    value = aws_vpc.this.id
}

output "vpc_cidr_block" {
    description = "EKS VPC cidr block."
    value = aws_vpc.this.cidr_block
}

output "private_subnet_ids" {
    description = "List of EKS Private Subnet IDs."
    value = aws_subnet.private[*].id
}

output "public_subnet_ids" {
    description = "List of EKS Public Subnet IDs."
    value = aws_subnet.public[*].id
}