locals {
  env = {
    default = {
      create_bucket                 = false
      bucket                        = "jdo-${terraform.workspace}"
      acl                           = "private"
      force_destroy                 = false # Allow deletion of non-empty bucket
      attach_lb_log_delivery_policy = false # Required for ALB/NLB logs
      versioning = {
        enabled = true
      }

      tags = {
        Environment = terraform.workspace
      }
    }
    dev = {
      create_bucket = true
    }
  }
  environmentvars = "${contains(keys(local.env), terraform.workspace)}" ? terraform.workspace : "default"
  # Permite tomar valores del env "default" en caso de no ser creados.
  workspace = merge(local.env["default"], local.env[local.environmentvars])
}