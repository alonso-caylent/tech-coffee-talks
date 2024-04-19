locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_vars     = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  # Extract out common variables for reuse
  region   = local.region_vars.locals.aws_region
  tags     = local.environment_vars.locals.tags
}

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.

terraform {
  source = "../../../../../modules/eks-blueprints"
}

dependency "network" {
  config_path = "../network/vpc"
}

dependency "eks" {
  config_path = "../eks"
}

# ---------------------------------------------------------------------------------------------------------------------
# Include configurations that are common used across multiple environments.
# ---------------------------------------------------------------------------------------------------------------------

# Include the root `terragrunt.hcl` configuration. The root configuration contains settings that are common across all
# components and environments, such as how to configure remote state.
include "root" {
  path = find_in_parent_folders()
}

## These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  region = local.region

  tags = local.tags

#################################################################################
## EKS BLUEPRINTS
#################################################################################
  enable_aws_load_balancer_controller = true
  enable_metrics_server               = true

#################################################################################
## DEPENDENCIES
#################################################################################
  vpc_id                              = dependency.network.outputs.vpc_id
  cluster_name                        = dependency.eks.outputs.cluster_name
  cluster_endpoint                    = dependency.eks.outputs.cluster_endpoint
  cluster_version                     = dependency.eks.outputs.cluster_version
  cluster_certificate_authority_data  = dependency.eks.outputs.cluster_certificate_authority_data
  oidc_provider_arn                   = dependency.eks.outputs.oidc_provider_arn
}