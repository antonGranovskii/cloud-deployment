locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("common.hcl"))

  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl", "empty.hcl"), { locals = {} })

  account_name = local.account_vars.locals.account_name
  account_id   = local.common_vars.locals.accounts[local.account_name]
  aws_region   = local.region_vars.locals.aws_region
  env          = local.env_vars.locals.env

  provider_vars   = read_terragrunt_config("${get_terragrunt_dir()}/provider.hcl", { locals = {} })
  provider_region = lookup(local.provider_vars.locals, "aws_region", local.aws_region)
}

remote_state {
  backend = "s3"
  config = {
    key = "${path_relative_to_include()}/backend.tfstate"
    bucket =  "${local.common_vars.locals.name_prefix}-${local.account_name}-${local.aws_region}-tf-state"
    encrypt = true
    region = local.aws_region
    dynamodb_table = "${local.common_vars.locals.name_prefix}-${local.account_name}-${local.aws_region}-tf-locks"
  }
  generate = {
    path = "state.tf"
    if_exists = "overwrite_terragrunt"
  }
}

generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"

  contents = <<EOF
provider "aws" {
  region = "${local.provider_region}"
  # Only these AWS Account IDs may be operated on by this template
  allowed_account_ids = ["${local.account_id}"]
  profile             = "terraform"

  assume_role {
    role_arn     = "arn:aws:iam::${local.account_id}:role/terraform"
    session_name = "terraform-session"
  }
}
EOF
}

inputs = merge(
  local.common_vars.locals,
  local.account_vars.locals,
  local.region_vars.locals,
  local.env_vars.locals,
  {
    aws_account_id = local.account_id
    aws_region     = local.aws_region

    path_relative_to_include = path_relative_to_include()

    resource_timeouts = {
      create = "10m"
      update = "10m"
      delete = "10m"
    }
  }
)