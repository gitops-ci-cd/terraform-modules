resource "aws_iam_policy" "main" {
  name        = "${var.name}-policy"
  description = var.description
  policy      = jsonencode(var.policy)

  tags = var.tags
}
