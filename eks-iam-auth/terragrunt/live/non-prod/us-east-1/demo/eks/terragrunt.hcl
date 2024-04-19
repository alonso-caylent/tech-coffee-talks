locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  account_vars     = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  # Extract out common variables for reuse
  env    = local.environment_vars.locals.environment
  tags   = local.environment_vars.locals.tags
  name  = local.environment_vars.locals.name
}

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.

terraform {
  source = "../../../../../modules/eks"
}

dependency "network" {
  config_path = "../network/vpc"
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
  name            = local.name
  cluster_version = 1.29

  tags = local.tags

#################################################################################
## DEPENDENCIES
#################################################################################
  vpc_id          = dependency.network.outputs.vpc_id
  private_subnets = dependency.network.outputs.private_subnets
  intra_subnets   = dependency.network.outputs.intra_subnets
}