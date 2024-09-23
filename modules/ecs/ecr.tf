resource "aws_ecr_repository" "image" {
  name                 = var.docker_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
