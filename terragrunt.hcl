locals {
  common_vars = read_terragrunt_config("${get_parent_terragrunt_dir()}/common/common.tf")
}

inputs = {
  COMMAND = get_terraform_cli_args()
  COMMAND_TAGS = local.common_vars.locals.tags
}

terraform {
  extra_arguments "init_arg" {
    commands = ["init"]
    arguments = [
      "-reconfigure"
    ]
    env_vars = {
      TERRAGRUNT_AUTO_INIT = false
    }
  }

  before_hook "use_workspace" {
    commands = ["workspace", "plan", "apply", "destroy", "refresh", "state", "output"]
    execute  = [
      "${get_parent_terragrunt_dir()}/helper.sh",
      "--dir-terraform",
      "${get_parent_terragrunt_dir()}",
      "--module-name",
      "${path_relative_to_include()}"
      ]
  }
}

generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
variable "workspace_iam_roles" {
  description = "Variable for credentials management"
  default = {
    dev = "${local.common_vars.locals.bucket_backend_profile}"
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = var.workspace_iam_roles[terraform.workspace]
}
EOF
}

remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
  config = {
    bucket               = local.common_vars.locals.bucket_backend_name
    profile              = local.common_vars.locals.bucket_backend_profile
    region               = local.common_vars.locals.aws_region
    workspace_key_prefix = "${path_relative_to_include()}"
    key                  = local.common_vars.locals.bucket_backend_key
    encrypt              = local.common_vars.locals.bucket_backend_encrypt
  }
}