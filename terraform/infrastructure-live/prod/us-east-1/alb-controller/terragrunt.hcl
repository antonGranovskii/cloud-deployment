terraform {
  source = "git::https://github.com/antonGranovskii/cloud-deployment.git//terraform/infrastructure-modules/alb-controller?ref=alb-controller-v0.0.1"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "env" {
  path           = find_in_parent_folders("env.hcl")
  expose         = true
  merge_strategy = "no_merge"
}

inputs = {

  aws_iam_openid_connect_provider_url = dependency.eks.outputs.aws_iam_openid_connect_provider_url
  
  env = include.env.locals.env

  aws_iam_openid_connect_provider_arn = dependency.eks.outputs.aws_iam_openid_connect_provider_arn

  eks_endpoint = dependency.eks.outputs.eks_endpoint

  eks_ca_certificate = dependency.eks.outputs.eks_ca_certificate

  eks_id = dependency.eks.outputs.eks_id
  
  eks_name = "${include.env.locals.env}"

  chart_version = "1.6.2"

  app_version = "v2.6.2"

  public_subnet_ids = toset(dependency.vpc.outputs.public_subnet_ids)

  private_subnet_ids = toset(dependency.vpc.outputs.private_subnet_ids)

  private_public_subnet_ids = toset(concat(dependency.vpc.outputs.public_subnet_ids, dependency.vpc.outputs.private_subnet_ids))

}

dependency "vpc" {
  config_path = "../vpc"

  mock_outputs = {
    public_subnet_ids = ["subnet-4321", "subnet-8765"]
    private_subnet_ids = ["subnet-1234", "subnet-5678"]
  }
}

dependency "eks" {
  config_path = "../eks"

  mock_outputs = {
    eks_endpoint         = "dummy"
    eks_ca_certificate = base64encode("fake-ca")
    eks_id               = "dummy"
    aws_iam_openid_connect_provider_url = "dummy"
    aws_iam_openid_connect_provider_arn = "dummy"
    eks_name = "dummy"
  }
}