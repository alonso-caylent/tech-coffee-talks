# Set common variables for the environment. This is automatically pulled in in the root terragrunt.hcl configuration to
# feed forward to the child modules.
locals {
  name        = "eks-iam-auth"
  environment = "demo"

  vpc_cidr = "10.0.0.0/23"

  tags = {
          "Environment": "demo",
          "Project": "eks-iam-auth"
        }
}