resource "aws_ecr_repository" "ecr_repository" {
  name         = "${var.project_name}-ecr"
  force_delete = true
  tags = {
    "Name"        = "${var.project_name}-ecr"
    "Environment" = "development"
  }
}

resource "aws_ecr_repository" "ecr_repository" {
  name         = "${var.project_name}-payment-ecr"
  force_delete = true
  tags = {
    "Name"        = "${var.project_name}-payment-ecr"
    "Environment" = "development"
  }
}

resource "aws_ecr_repository" "ecr_repository" {
  name         = "${var.project_name}-kitchen-ecr"
  force_delete = true
  tags = {
    "Name"        = "${var.project_name}-kitchen-ecr"
    "Environment" = "development"
  }
}
