resource "aws_ecr_repository" "ecr_repository" {
  name         = "${var.project_name}-ecr"
  force_delete = true
  tags = {
    "Name"        = "${var.project_name}-ecr"
    "Environment" = "development"
  }
}
