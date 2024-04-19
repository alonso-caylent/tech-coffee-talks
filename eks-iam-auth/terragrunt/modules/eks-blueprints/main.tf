provider "kubernetes" {
  host                   = var.cluster_endpoint
  cluster_ca_certificate = base64decode(var.cluster_certificate_authority_data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    # This requires the awscli to be installed locally where Terraform is executed
    args = ["eks", "get-token", "--cluster-name", var.cluster_name]
  }
}

provider "helm" {
  kubernetes {
    host                   = var.cluster_endpoint
    cluster_ca_certificate = base64decode(var.cluster_certificate_authority_data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      # This requires the awscli to be installed locally where Terraform is executed
      args = ["eks", "get-token", "--cluster-name", var.cluster_name]
    }
  }
}

################################################################################
# EKS Blueprints v5
################################################################################
module "eks_blueprints_addons" {
  source = "aws-ia/eks-blueprints-addons/aws"
  version = "1.16.2" #ensure to update this to the latest/desired version
  
  cluster_name      = var.cluster_name
  cluster_endpoint  = var.cluster_endpoint
  cluster_version   = var.cluster_version
  oidc_provider_arn = var.oidc_provider_arn

  enable_metrics_server         = var.enable_metrics_server 

  ################################################################################
  # AWS Load Balancer Controller
  ################################################################################
  enable_aws_load_balancer_controller    = var.enable_aws_load_balancer_controller
  aws_load_balancer_controller = {
    chart_version = "1.7.2"
    # NOTE: Need to set the following parameters when running in Fargate Profile
    set = [
      {
        "name" : "enableServiceMutatorWebhook"
        "value" : false
      },
      {
        "name" : "region"
        "value" : var.region
      },
      {
        "name" : "vpcId"
        "value" : var.vpc_id
      }
    ]
  }
}