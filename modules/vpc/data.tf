# Fetch all existing VPCs
data "aws_vpcs" "existing" {}

# Fetch CIDR blocks of all existing VPCs
data "aws_vpc" "details" {
  count = length(tolist(data.aws_vpcs.existing.ids))
  id    = tolist(data.aws_vpcs.existing.ids)[count.index]
}
