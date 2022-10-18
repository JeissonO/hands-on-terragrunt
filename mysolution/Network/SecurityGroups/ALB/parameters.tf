locals {
  env = {
    default = {
      create          = false
      name            = "alb-main-${terraform.workspace}"
      vpc_id          = var.vpc_id
      use_name_prefix = false
      ingress_with_cidr_blocks = [
        {
          rule        = "mssql-tcp"
          cidr_blocks = "0.0.0.0/0"
        }
      ]
      egress_with_cidr_blocks = [
        {
          rule        = "all-tcp"
          cidr_blocks = "0.0.0.0/0"
        }
      ]
      ingress_with_source_security_group_id = []
      egress_with_source_security_group_id  = []
      tags = {
        Environment = terraform.workspace
      }
    }
    dev = {
      create = true
    }
  }
  environmentvars = "${contains(keys(local.env), terraform.workspace)}" ? terraform.workspace : "default"
  # Permite tomar valores del env "default" en caso de no ser creados.
  workspace = merge(local.env["default"], local.env[local.environmentvars])
}