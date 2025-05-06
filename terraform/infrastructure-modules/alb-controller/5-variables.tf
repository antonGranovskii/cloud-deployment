variable "env" {
  description = "Environment name."
  type        = string
}

variable "aws_iam_openid_connect_provider_url" {
  description = "URL of the IAM OIDC provider associated with the EKS cluster. Used for IAM Roles for Service Accounts (IRSA)."
  type    = string
  default = ""
}

variable "aws_iam_openid_connect_provider_arn" {
  description = "ARN of the IAM OIDC provider associated with the EKS cluster. Required to bind IAM policies to the service account."
  type    = string
}

variable "eks_endpoint" {
description = "API server endpoint of the EKS cluster, used for configuring access and Helm provider."
  type    = string
}

variable "eks_ca_certificate" {
  description = "Base64-encoded certificate authority data for the EKS cluster. Required to authenticate Helm against the EKS API server."
  type    = string
}

variable "eks_id" {
  description = "Unique identifier of the EKS cluster. Often used for tagging and referencing in AWS resources."
  type    = string
}

variable "chart_version" {
  description = "Version of the AWS Load Balancer Controller Helm chart to be installed."
  type    = string
}

variable "app_version" {
  description = "Version of the AWS Load Balancer Controller application to deploy."
  type    = string
}

variable "service_account_name" {
  description = "Name of the Kubernetes service account that the ALB controller will use. This should be annotated for IRSA."
  type    = string
  default = "aws-load-balancer-controller"
}


variable "public_subnet_ids" {
  description = "Set of public subnet IDs where internet-facing ALBs can be created."
  type    = set(string)
}

variable "private_subnet_ids" {
  description = "Set of private subnet IDs where internal ALBs can be created."
  type    = set(string)
}

variable "private_public_subnet_ids" {
  description = "Combined set of both private and public subnet IDs. Used if the controller needs to manage both types."
  type    = set(string)
}
