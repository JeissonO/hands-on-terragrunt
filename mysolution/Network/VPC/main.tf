module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  create_vpc = local.workspace["create"]

  name = local.workspace["name"]
  cidr = local.workspace["cidr"]

  enable_dns_hostnames = local.workspace["enable_dns_hostnames"]
  enable_dns_support   = local.workspace["enable_dns_support"]

  azs             = local.workspace["azs"]
  private_subnets = local.workspace["private_subnets"]
  public_subnets  = local.workspace["public_subnets"]

  enable_nat_gateway = local.workspace["enable_nat_gateway"]
  single_nat_gateway = local.workspace["single_nat_gateway"]

  tags = merge(
    var.COMMAND_TAGS,
    local.workspace["tags"]
  )
}