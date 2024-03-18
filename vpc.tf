resource "aws_eip" "nat" {
  count = length(var.public_subnet_cidrs)

  domain = "vpc" # Atualizado conforme recomendado pelo aviso
  tags = {
    Name = "${var.project_name}-EIP-${count.index}"
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.6.0"

  name = "${var.project_name}-vpc"
  cidr = var.vpc_cidr
  azs  = data.aws_availability_zones.available.names

  public_subnets  = var.public_subnet_cidrs
  private_subnets = var.private_subnet_cidrs

  enable_nat_gateway  = true
  single_nat_gateway  = true
  
  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }

  tags = {
    Name        = "${var.project_name}-vpc"
    Environment = "development"
  }
}
