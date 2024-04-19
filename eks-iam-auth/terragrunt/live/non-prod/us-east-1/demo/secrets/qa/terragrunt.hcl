# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = include.envcommon.locals.base_source_url
}

dependency "eks" {
  config_path = "../../eks"
}

# ---------------------------------------------------------------------------------------------------------------------
# Include configurations that are common used across multiple environments.
# ---------------------------------------------------------------------------------------------------------------------

# Include the root `terragrunt.hcl` configuration. The root configuration contains settings that are common across all
# components and environments, such as how to configure remote state.
include "root" {
  path = find_in_parent_folders()
}

# Include the envcommon configuration for the component. The envcommon configuration contains settings that are common
# for the component across all environments.
include "envcommon" {
  path   = "${dirname(find_in_parent_folders())}/_envcommon/secretsmanager.hcl"
  expose = true
}

## These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  name = "qa-secret"

  tags = {
    "kubernetes-namespace" = "qa"
    "eks-cluster-name" = dependency.eks.outputs.cluster_name
  }
}