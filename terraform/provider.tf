locals {
  region          = "us-east-1"
  name            = "tws-eks-cluster"
  vpc_cidr        = "10.0.0.0/16"
  
  # Updated AZs for N. Virginia
  azs             = ["us-east-1a", "us-east-1b"]
  
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]

  tags = {
    example = local.name
  }
}

provider "aws" {
  region = local.region
}

# Add this block to allow Terraform to authenticate with EKS
# This resolves the 'kubernetes_config_map' error
provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
    command     = "aws"
  }
}