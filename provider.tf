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
    bucket = "${TERRAFORM_BUCKET_NAME}"
    # bucket = "terraformfiap"
    key    = "burgerroyale-kubernets.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region  = var.aws_region
  profile = "lab"
  default_tags {
    tags = var.tags
  }
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.burgercluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.burgercluster.certificate_authority[0].data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.burgercluster.name]
  }
#  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.burgercluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.burgercluster.certificate_authority[0].data)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.burgercluster.name]
    }

    #  config_path = "~/.kube/config"
  }
}
