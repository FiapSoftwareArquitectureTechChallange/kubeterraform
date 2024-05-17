locals {
  account_id = data.aws_caller_identity.current.account_id
  LabRoleArn = "arn:aws:iam::${local.account_id}:role/${var.LabRoleName}"
  PrincipalArn = "arn:aws:iam::${local.account_id}:role/${var.PrincipalRoleName}"
}

resource "aws_security_group" "burgerroyale_default_security_group" {
  vpc_id = data.aws_vpc.vpc.id

  tags = {
    Name = "${var.project_name}_default_security_group"
  }
}

resource "aws_security_group_rule" "allow_eks_to_rds" {
  type                     = "ingress"
  from_port                = 1433  
  to_port                  = 1433
  protocol                 = "tcp"
  security_group_id        = aws_security_group.burgerroyale_default_security_group.id
  source_security_group_id = data.aws_security_group.secgroup.id
}

resource "aws_eks_cluster" "burgercluster" {
  name     = var.cluster_name
  role_arn = local.LabRoleArn
  version  = var.cluster_version
 
 vpc_config {
    subnet_ids             = [data.aws_subnet.private_subnet_1.id, data.aws_subnet.private_subnet_2.id]
    security_group_ids     = [data.aws_security_group.secgroup.id]
    endpoint_public_access = true
  }

  tags = {
    Environment = "development"
    Project     = var.project_name
  }
}

resource "aws_eks_node_group" "node_group_burger" {
  cluster_name    = aws_eks_cluster.burgercluster.name
  node_group_name = "node_group_burger"
  node_role_arn   = local.LabRoleArn

  subnet_ids = [data.aws_subnet.private_subnet_1.id, data.aws_subnet.private_subnet_2.id]

  scaling_config {
    desired_size = var.node_group_desired_capacity
    max_size     = var.node_group_max_capacity
    min_size     = var.node_group_min_capacity
  }

  instance_types = [var.node_group_instance_type]

  tags = {
    Environment = "development"
    Project     = var.project_name
  }
}

resource "aws_eks_addon" "vpc_cni" {
  cluster_name  = aws_eks_cluster.burgercluster.name
  addon_name    = "vpc-cni"
  addon_version = "v1.18.1-eksbuild.1"

  tags = {
    Environment = "development"
    Project     = var.project_name
  }
}


resource "helm_release" "metrics_server" {
  name       = "metrics-server"
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  namespace  = "kube-system"

  set {
    name  = "args"
    value = "{--kubelet-preferred-address-types=InternalIP}"
  }

  set {
    name  = "replicas"
    value = "2"
  }

  depends_on = [
    aws_eks_cluster.burgercluster,
    aws_eks_addon.vpc_cni
  ]
}

resource "aws_eks_access_policy_association" "policy" {
  cluster_name  = aws_eks_cluster.burgercluster.name
  principal_arn = local.PrincipalArn
  policy_arn    = var.policyarn
  access_scope {
    type = "cluster"
  }
  depends_on = [
    aws_eks_cluster.burgercluster
  ]
}

resource "aws_eks_access_entry" "access" {
  cluster_name      = aws_eks_cluster.burgercluster.name
  principal_arn     = local.PrincipalArn
  kubernetes_groups = ["fiap", "pos-tech"]
  type              = "STANDARD"

  depends_on = [
    aws_eks_cluster.burgercluster
  ]
}
