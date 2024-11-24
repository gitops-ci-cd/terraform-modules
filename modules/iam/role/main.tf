resource "aws_iam_role" "main" {
  name               = "${var.name}-role"
  assume_role_policy = jsonencode(var.assume_role_policy)

  tags = var.tags
}
