# Calculate the next available CIDR block
locals {
  existing_cidrs = [for vpc in data.aws_vpc.details : vpc.cidr_block]
  base_cidr      = "10.0.0.0/16"
  increment      = 16777216 # 0.1.0.0 in decimal
  next_cidr      = cidrsubnet(local.base_cidr, 8, length(local.existing_cidrs))
}

# Create the VPC
resource "aws_vpc" "main" {
  cidr_block           = coalesce(var.cidr_block, local.next_cidr)
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = var.tags
}

# Automatically create public and private subnets
resource "aws_subnet" "public" {
  count = var.public_subnet_count

  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  map_public_ip_on_launch = true

  tags = merge(
    {
      "kubernetes.io/role/elb"                                                 = "1"     # Required for public ALBs
      "kubernetes.io/cluster/${var.tags.Name}-${var.tags.Environment}-cluster" = "owned" # Associates with a K8s cluster
    },
    var.tags
  )
}

resource "aws_subnet" "private" {
  count = var.private_subnet_count

  vpc_id     = aws_vpc.main.id
  cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 8, var.public_subnet_count + count.index)

  tags = merge(
    {
      "kubernetes.io/role/internal-elb"                                        = "1"     # Required for internal ALBs
      "kubernetes.io/cluster/${var.tags.Name}-${var.tags.Environment}-cluster" = "owned" # Associates with a K8s cluster
    },
    var.tags
  )
}

# Internet Gateway
resource "aws_internet_gateway" "public" {
  count  = var.enable_internet_gateway ? 1 : 0
  vpc_id = aws_vpc.main.id

  tags = var.tags
}

# Route Table for Public Subnets
resource "aws_route_table" "public" {
  count  = var.enable_internet_gateway ? 1 : 0
  vpc_id = aws_vpc.main.id

  tags = var.tags
}

resource "aws_route" "public" {
  count = var.enable_internet_gateway ? 1 : 0

  route_table_id         = aws_route_table.public[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.public[count.index].id
}

resource "aws_route_table_association" "public" {
  for_each = zipmap(
    [for i in range(var.public_subnet_count) : i],
    aws_subnet.public.*.id
  )

  subnet_id      = each.value
  route_table_id = aws_route_table.public[0].id
}

# Optional NAT Gateway for Private Subnets
resource "aws_eip" "nat" {
  count = var.enable_nat_gateway ? 1 : 0

  tags = var.tags
}

resource "aws_nat_gateway" "nat" {
  count         = var.enable_nat_gateway ? 1 : 0
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[0].id

  tags = var.tags
}

resource "aws_route_table" "private" {
  count  = var.enable_nat_gateway ? 1 : 0
  vpc_id = aws_vpc.main.id

  tags = var.tags
}

resource "aws_route" "private" {
  count = var.enable_nat_gateway ? 1 : 0

  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat[count.index].id
}

resource "aws_route_table_association" "private" {
  for_each = zipmap(
    [for i in range(var.private_subnet_count) : i],
    aws_subnet.private.*.id
  )

  subnet_id      = each.value
  route_table_id = aws_route_table.private[0].id
}
