terraform {
  source = "git::https://github.com/antonGranovskii/cloud-deployment.git//terraform/infrastructure-modules/eks?ref=eks-v0.0.1"
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
  eks_version             = "1.32"
  env                     = include.env.locals.env
  eks_name                = "${include.env.locals.env}"
  vpc_id                  = dependency.vpc.outputs.vpc_id
  vpc_cidr_block          = dependency.vpc.outputs.vpc_cidr_block
  subnet_ids              = dependency.vpc.outputs.private_subnet_ids
  eks_volume_size         = "20"
  launch_template_version = "1"

  eks_worker_sg_tags = {
    "kubernetes.io/cluster/production" = "owned"
  }

  node_groups = {
    general = {
      capacity_type  = "ON_DEMAND"
      instance_types = ["t3.medium"]
      scaling_config = {
        desired_size = 2
        max_size     = 10
        min_size     = 1
      }
      update_config = {
        max_unavailable = 1
      }
    }
  }
}

dependency "vpc" {
  config_path = "../vpc"

  mock_outputs = {
    vpc_id             = "vpc-12345678"
    vpc_cidr_block     = "10.0.0.0/16"
    private_subnet_ids = ["subnet-1234", "subnet-5678"]
  }
}