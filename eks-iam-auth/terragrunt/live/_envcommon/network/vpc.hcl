# ---------------------------------------------------------------------------------------------------------------------
# COMMON TERRAGRUNT CONFIGURATION
# This is the common component configuration for vpc. The common variables for each environment to
# deploy vpc are defined here. This configuration will be merged into the environment configuration
# via an include block.
# ---------------------------------------------------------------------------------------------------------------------

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder. If any environment
# needs to deploy a different module version, it should redefine this block with a different ref to override the
# deployed version.
terraform {
  source = local.base_source_url
}

# ---------------------------------------------------------------------------------------------------------------------
# Locals are named constants that are reusable within the configuration.
# ---------------------------------------------------------------------------------------------------------------------
locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  account_vars     = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  # Extract out common variables for reuse
  env    = local.environment_vars.locals.environment
  cidr   = local.environment_vars.locals.vpc_cidr
  tags   = local.environment_vars.locals.tags
  region = local.region_vars.locals.aws_region
  azs    = local.region_vars.locals.azs
  name  = local.environment_vars.locals.name

  # Expose the base source URL so different versions of the module can be deployed in different environments. This will
  # be used to construct the terraform block in the child terragrunt configurations.
  base_source_url = "tfr:///terraform-aws-modules/vpc/aws?version=5.7.1"
}

# ---------------------------------------------------------------------------------------------------------------------
# MODULE PARAMETERS
# These are the variables we have to pass in to use the module. This defines the parameters that are common across all
# environments.
# ---------------------------------------------------------------------------------------------------------------------
inputs = {
  name   = "${local.env}-${local.name}"
  region = local.region

  cidr                = local.cidr
  private_subnets     = [for k, v in local.azs : cidrsubnet(local.cidr, 4, k)]
  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
    # Tags subnets for Karpenter auto-discovery
    "karpenter.sh/discovery" = "${local.name}"
  }
  public_subnets      = [for k, v in local.azs : cidrsubnet(local.cidr, 4, k + 2)]
  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }
  intra_subnets       = [for k, v in local.azs : cidrsubnet(local.cidr, 5, k + 8)]
  intra_subnet_suffix = "tgw"

  vpc_tags = {
    Name = "${local.env}-${local.name}-vpc"
  }

  igw_tags = {
    Name = "${local.env}-${local.name}-igw"
  }

  nat_gateway_tags = {
    Name = "${local.env}-${local.name}-natgw"
  }

  create_database_subnet_group = false
  enable_nat_gateway           = true
  single_nat_gateway           = true
  one_nat_gateway_per_az       = false
  enable_vpn_gateway           = false

  # VPC Flow Logs (Cloudwatch log group and IAM role will be created)
  enable_flow_log                                 = true
  create_flow_log_cloudwatch_log_group            = true
  create_flow_log_cloudwatch_iam_role             = true
  flow_log_max_aggregation_interval               = 60
  flow_log_cloudwatch_log_group_retention_in_days = 90

  tags = local.tags
}