locals {
  full_domain_name = "${var.subdomain}.${var.domain_name}"
}

# Hosted Zone
module "hosted_zone" {
  source = "../hosted-zone"

  domain_name = var.domain_name

  tags = var.tags
}

# DNS Record
module "dns_record" {
  source = "../dns-record"

  zone_id = module.hosted_zone.zone_id
  records = {
    (var.subdomain) = {
      name                   = local.full_domain_name
      type                   = "A"
      ttl                    = 300
      alias_name             = aws_lb.main.dns_name
      alias_zone_id          = aws_lb.main.zone_id
      evaluate_target_health = true
    }
  }
}

resource "aws_lb_target_group" "main" {
  name        = "${var.name}-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
    protocol            = "HTTP"
  }

  tags = var.tags
}

# Create an ALB or NLB based on the `type` variable
resource "aws_lb" "main" {
  name                       = "${var.name}-lb"
  internal                   = var.internal
  load_balancer_type         = var.type
  security_groups            = var.security_groups
  subnets                    = var.subnets
  enable_deletion_protection = var.enable_deletion_protection

  tags = var.tags
}

module "certificate" {
  source = "../certificate"

  domain_name = local.full_domain_name
  zone_id     = module.hosted_zone.zone_id

  tags = var.tags
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.main.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = module.certificate.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }

  tags = var.tags
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  tags = var.tags
}
