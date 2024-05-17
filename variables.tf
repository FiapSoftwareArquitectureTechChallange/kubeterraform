variable "aws_region" {
  description = "Região da AWS para provisionar os recursos."
  default     = "us-east-1"
}

variable "project_name" {
  description = "Nome do projeto, usado para taggear os recursos."
  default     = "burgerroyale"
}

variable "vpc_cidr" {
  description = "CIDR block para a VPC."
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  default = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "cluster_name" {
  description = "Nome do cluster EKS."
  default     = "burger-cluster-eks"
}

variable "cluster_version" {
  description = "Versão do Kubernetes para o cluster EKS."
  type        = string
  default     = "1.29"
}

variable "node_group_desired_capacity" {
  description = "Número desejado de instâncias no node group do EKS."
  type        = number
  default     = 2
}

variable "node_group_max_capacity" {
  description = "Número máximo de instâncias no node group do EKS."
  type        = number
  default     = 3
}

variable "node_group_min_capacity" {
  description = "Número mínimo de instâncias no node group do EKS."
  type        = number
  default     = 1
}

variable "node_group_instance_type" {
  description = "Tipo de instância EC2 para os nodes do EKS."
  type        = string
  default     = "t2.micro"
}

variable "LabRoleName" {
  description = "Name for the LabRole IAM role"
  default     = "LabRole"
}

variable "PrincipalRoleName" {
  description = "Name for the Principal IAM role"
  default     = "voclabs"
}

variable "policyarn" {
  default = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
}

variable "tags" {
  description = "Mapa de tags aplicadas a todos os recursos criados."
  type        = map(string)
  default = {
    App      = "burgerroyale",
    Ambiente = "Desenvolvimento"
  }
}

variable "acessConfig" {
  default = "API_AND_CONFIG_MAP"
}