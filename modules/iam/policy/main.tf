resource "aws_iam_policy" "policy" {
  name        = var.name
  description = var.description
  policy      = jsonencode(var.policy)

  tags = var.tags
}
