# Terragrunt-lab
Terragrunt lab

## Update your terragrunt configuration file

### common values in common/common.tf

Update the following properties that going to be used in the *terragrunt.hcl* configuration file

```tf
locals {
  aws_region             = "us-east-1"
  bucket_backend_name    = "<put your bucket name here>"
  bucket_backend_profile = "<AWS profile here>"
  bucket_backend_key     = "terraform.tfstate"
  bucket_backend_encrypt = false
  tags = {
    Terraform = "True"
    Owner     = "<user mail or owner id>"
  }
}

```
### terragrunt main configuration file in /terragrunt.hcl

Update the configuration blocks as you required, by default the configuration in this project use all values from `common/common.tf` file

### Generate your aws credentials
- Export AWS environment variables
- Generate SSO token 
- Define AWS profile

example with sso:
```sh
aws sso login --profile <aws_profile>
```

### Execute terragrunt commands
```sh
# init all projects
terragrunt run-all init
```
```sh
# define the new "dev" workspace in all terraform projects
terragrunt run-all workspace new dev
```

```sh
# Run terraform plan in all projects
terragrunt run-all plan
```

```sh
# Run terraform apply in all projects
terragrunt run-all apply
```

```sh
# Run terraform destroy in all projects
terragrunt run-all destroy
```