resource "aws_ecr_repository" "ecr_repository" {
  name = "${var.project_name}-ecr"

  tags = {
    "Name"        = "${var.project_name}-ecr"
    "Environment" = "development"
  }
}
