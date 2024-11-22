# Fetch all existing VPCs
data "aws_vpcs" "existing" {}

# Fetch CIDR blocks of all existing VPCs
data "aws_vpc" "details" {
  count = length(data.aws_vpcs.existing.ids)
  id    = data.aws_vpcs.existing.ids[count.index]
}
