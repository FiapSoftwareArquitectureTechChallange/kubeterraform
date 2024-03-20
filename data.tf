
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

data "aws_security_group" "secgroup"{
  tags = {
    Name = "${var.project_name}_default_security_group"
  }

}