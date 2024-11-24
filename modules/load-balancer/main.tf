# Create an ALB or NLB based on the `type` variable
resource "aws_lb" "main" {
  name                       = var.name
  internal                   = var.internal
  load_balancer_type         = var.type
  security_groups            = var.security_groups
  subnets                    = var.subnets
  enable_deletion_protection = var.enable_deletion_protection

  tags = var.tags
}
