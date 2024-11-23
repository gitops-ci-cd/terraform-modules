output "vpc_id" {
  description = "The ID of the created VPC."
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "The IDs of the created public subnets."
  value       = aws_subnet.public.*.id
}

output "private_subnet_ids" {
  description = "The IDs of the created private subnets."
  value       = aws_subnet.private.*.id
}

output "internet_gateway_ids" {
  description = "The ID of the Internet Gateway."
  value       = aws_internet_gateway.igw.*.id
}

output "nat_gateway_ids" {
  description = "The ID of the NAT Gateway (if enabled)."
  value       = aws_nat_gateway.nat.*.id
}
