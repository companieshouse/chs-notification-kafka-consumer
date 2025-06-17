data "aws_caller_identity" "current" {}

data "aws_vpc" "lookup" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_pattern]
  }
}

data "aws_subnets" "lookup" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.lookup.id]
  }
  filter {
    name   = "tag:Name"
    values = [var.subnet_pattern]
  }
}

data "aws_subnet" "lookup" {
  for_each = toset(data.aws_subnets.lookup.ids)

  id = each.value
}
