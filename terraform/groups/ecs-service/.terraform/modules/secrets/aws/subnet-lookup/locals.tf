locals {

  subnet_cidrs = {
    for subnet in data.aws_subnet.lookup : subnet.tags["Name"] => subnet.cidr_block
  }

}
