terraform {
  source = "git::https://github.com/antonGranovskii/cloud-deployment.git//terraform/infrastructure-modules/vpc?ref=vpc-v0.0.1"
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
  env             = include.env.locals.env
  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.0.0/24", "10.0.1.0/24"]
  public_subnets  = ["10.0.2.0/24", "10.0.3.0/24"]

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
    "kubernetes.io/cluster/production"  = "owned"
  }

  public_subnet_tags = {
    "kubernetes.io/role/elb"         = 1
    "kubernetes.io/cluster/production" = "owned"
  }
}