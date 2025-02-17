locals {
  aws_region             = "us-east-1"
  bucket_backend_name    = "jeisson-osorio"
  bucket_backend_profile = "jdo-dev"
  bucket_backend_key     = "terraform.tfstate"
  bucket_backend_encrypt = false
  tags = {
    Terraform  = "true"
    Terragrunt = "true"
    Owner      = var.owner_email
  }
}
