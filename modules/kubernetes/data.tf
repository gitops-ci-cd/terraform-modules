# Fetch all subnets for the specified VPC
data "aws_subnets" "all" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

# Fetch only private subnets if required
data "aws_subnet" "private" {
  for_each = toset(data.aws_subnets.all.ids)

  id = each.key

  filter {
    name   = "tag:Name"
    values = ["*private*"] # Assumes your subnets are tagged with "private" in their names
  }
}
