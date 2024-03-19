module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "~> 20.5"
  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  subnet_ids      = [data.aws_subnet.private_subnet_1.id,data.aws_subnet.private_subnet_2.id]
  vpc_id          = data.aws_vpc.vpc.id
  cluster_endpoint_public_access = true
  enable_cluster_creator_admin_permissions = true

  eks_managed_node_groups = {
    node_group_burger = {
      desired_capacity = var.node_group_desired_capacity
      max_capacity     = var.node_group_max_capacity
      min_capacity     = var.node_group_min_capacity
      instance_type    = var.node_group_instance_type
    }
  }

  tags = {
    Environment = "development"
    Project     = var.project_name
  }
}

module "eks_blueprints_addons" {
  source  = "aws-ia/eks-blueprints-addons/aws"
  version = "~> 1.15"

  oidc_provider_arn = module.eks.oidc_provider_arn
  cluster_name      = module.eks.cluster_name
  cluster_endpoint  = module.eks.cluster_endpoint
  cluster_version   = module.eks.cluster_version
  enable_metrics_server = true

    tags = {
    Environment = "development"
    Project     = var.project_name
  }

  depends_on = [
    module.eks
  ]
}


resource "helm_release" "csi-secrets-store" {
  name       = "csi-secrets-store"
  repository = "https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts"
  chart      = "secrets-store-csi-driver"
  namespace  = "kube-system"

  set {
    name  = "syncSecret.enabled"
    value = "true"
  }
  set {
    name  = "enableSecretRotation"
    value = "true"
  }

  depends_on = [
    module.eks,
    module.eks_blueprints_addons
  ]
}

resource "helm_release" "secrets-provider-aws" {
  name       = "secrets-provider-aws"
  repository = "https://aws.github.io/secrets-store-csi-driver-provider-aws"
  chart      = "secrets-store-csi-driver-provider-aws"
  namespace  = "kube-system"

  depends_on = [
    module.eks,
    module.eks_blueprints_addons,
    helm_release.csi-secrets-store
  ]
}
