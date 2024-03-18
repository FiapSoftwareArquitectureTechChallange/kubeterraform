terraform {
  
  required_version = ">= 1.3"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

     helm = {
      source  = "hashicorp/helm"
      version = ">= 2.12"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.26"
    }
  }

  backend "s3" {
    bucket = "burgerroyale-s3-bucket-terraform"
    key    = "burgerroyale-auth.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  profile = "default"
  region  = var.aws_region

  default_tags {
    tags = var.tags
  }
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

  # exec {
  #   api_version = "client.authentication.k8s.io/v1beta1"
  #   command     = "aws"

  #   args = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
  # }
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    config_path    = "~/.kube/config"
    config_context = "arn:aws:eks:us-east-1:992382847853:cluster/burger-cluster-eks"
    # exec {
    #   api_version = "client.authentication.k8s.io/v1beta1"
    #   command     = "aws"

    #   args = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
    # }
  }
}
