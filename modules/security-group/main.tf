resource "aws_security_group" "main" {
  name        = var.name
  description = var.description
  vpc_id      = var.vpc_id

  tags = var.tags
}

resource "aws_security_group_rule" "ingress" {
  for_each = { for i, rule in var.ingress_rules : i => rule }

  security_group_id        = aws_security_group.main.id
  type                     = "ingress"
  from_port                = each.value.from_port
  to_port                  = each.value.to_port
  protocol                 = each.value.protocol
  cidr_blocks              = each.value.cidr_blocks
  ipv6_cidr_blocks         = each.value.ipv6_cidr_blocks
  source_security_group_id = length(each.value.security_groups) > 0 ? each.value.security_groups[0] : null
  description              = each.value.description
}

resource "aws_security_group_rule" "egress" {
  for_each = { for i, rule in var.egress_rules : i => rule }

  security_group_id        = aws_security_group.main.id
  type                     = "egress"
  from_port                = each.value.from_port
  to_port                  = each.value.to_port
  protocol                 = each.value.protocol
  cidr_blocks              = each.value.cidr_blocks
  ipv6_cidr_blocks         = each.value.ipv6_cidr_blocks
  source_security_group_id = length(each.value.security_groups) > 0 ? each.value.security_groups[0] : null
  description              = each.value.description
}
