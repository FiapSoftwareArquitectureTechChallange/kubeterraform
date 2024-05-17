data "aws_caller_identity" "current" {}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_subnet" "private_subnet_1" {
  tags = {
    Name = "${var.project_name}_private_subnet_1"
  }
}

data "aws_subnet" "private_subnet_2" {
  tags = {
    Name = "${var.project_name}_private_subnet_2"
  }
}

data "aws_vpc" "vpc" {
  tags = {
    Name = "${var.project_name}_vpc"
  }
}

data "aws_security_group" "secgroup" {
  filter {
    name   = "tag:Name"
    values = ["${var.project_name}_default_security_group"]
  }

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }

    filter {
    name   = "tag:Ambiente"
    values = ["Desenvolvimento"]
  }

  filter {
    name   = "tag:App"
    values = ["burgerroyale"]
  }
}

data "aws_eks_cluster" "burgercluster" {
  depends_on = [aws_eks_cluster.burgercluster]
  name       = aws_eks_cluster.burgercluster.name
}

data "aws_eks_cluster_auth" "burgercluster" {
  depends_on = [aws_eks_cluster.burgercluster]
  name       = aws_eks_cluster.burgercluster.name
}
