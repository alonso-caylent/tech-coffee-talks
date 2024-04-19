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
  source = "../../../../../../../modules/iam-role/secret-app"
}

dependency "eks" {
  config_path = "../../../eks"
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
  name            = "secret-app-dev-eks-pod-identity-role"
  namespace       = "dev"
  service_account = "secretmgr-app-sa"

  tags = local.tags

#################################################################################
## DEPENDENCIES
#################################################################################
  cluster_name = dependency.eks.outputs.cluster_name
}

