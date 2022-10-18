locals {
  env = {
    default = {
      create               = false
      name                 = "jdo-${terraform.workspace}"
      cidr                 = "mock-cidr"
      enable_dns_hostnames = true
      enable_dns_support   = true
      azs                  = ["us-east-1a", "us-east-1b"]
      private_subnets      = []
      public_subnets       = []
      enable_nat_gateway   = false
      single_nat_gateway   = true
      enable_vpn_gateway   = false
      tags = {
        Environment = terraform.workspace
      }
    }
    dev = {
      create          = true
      cidr            = "10.10.0.0/16"
      azs             = ["us-east-1a", "us-east-1b"]
      private_subnets = ["10.10.1.0/24", "10.10.2.0/24"]
      public_subnets  = ["10.10.3.0/24", "10.10.4.0/24"]
    }
  }
  environmentvars = "${contains(keys(local.env), terraform.workspace)}" ? terraform.workspace : "default"
  # Permite tomar valores del env "default" en caso de no ser creados.
  workspace = merge(local.env["default"], local.env[local.environmentvars])
}