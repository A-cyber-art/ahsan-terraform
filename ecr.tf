resource "aws_ecr_repository" "employee_app" {
  name = "employee-app"

  image_scanning_configuration {
    scan_on_push = true
  }
}
