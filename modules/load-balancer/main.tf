# Create an ALB or NLB based on the `type` variable
resource "aws_lb" "load_balancer" {
  name               = var.name
  internal           = var.internal
  load_balancer_type = var.type
  security_groups    = var.type == "application" ? var.security_groups : null
  subnets            = var.subnets
  enable_deletion_protection = var.enable_deletion_protection

  tags = merge(
    {
      Name = var.name
    },
    var.tags
  )
}
