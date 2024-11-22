# Extract role name from the provided role ARN
resource "aws_iam_role_policy_attachment" "attachment" {
  role       = replace(var.role_arn, "arn:aws:iam::\\d+:role/", "")
  policy_arn = var.policy_arn
}
