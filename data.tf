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
    values = ["burgerroyale_default_security_group"]
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
