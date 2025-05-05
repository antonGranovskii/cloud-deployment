variable "env" {
  description = "Environment name."
  type        = string
}

variable "eks_volume_size" {
  description = "EKS Nodes Volume Size."
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR range for VPC."
  type        = string
}

variable "ingress_ports" { #?
  description = "The ports to allow ingress (e.g., 443 for Kubernetes API)"
  type        = list(number)
  default     = [443]
}

variable "launch_template_version" {
  description = "EKS Node Launch Template Version."
  type        = string
}

variable "eks_version" {
  description = "Desired Kubernetes master version."
  type        = string
}

variable "eks_name" {
  description = "Name of the cluster."
  type        = string
}

variable "vpc_id" {
  description = "List of subnet IDs. Must be in at least two different availability zones."
  type        = string
}


variable "subnet_ids" {
  description = "List of subnet IDs. Must be in at least two different availability zones."
  type        = list(string)
}

variable "node_iam_policies" {
  description = "List of IAM Policies to attach to EKS-managed nodes."
  type        = map(any)
  default = {
    1 = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
    2 = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    3 = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    4 = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }
}

variable "node_groups" {
  description = "EKS node groups."
  type        = map(any)
}

variable "enable_irsa" {
  description = "Determines whether to create an OpenID Connect Provider for EKS to enable IRSA."
  type        = bool
  default     = true
}

variable "eks_worker_sg_tags" {
  description = "EKS worker nodes tags."
  type        = map(any)
}
