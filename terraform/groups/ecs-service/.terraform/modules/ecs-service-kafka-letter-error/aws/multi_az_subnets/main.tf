resource "aws_subnet" "main" {
  for_each = local.addrs_by_name

  vpc_id            = var.vpc_id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone

  tags = merge(
    {
      "Name"      = each.value.name,
      "Terraform" = "true",
    },
    var.tags,
  )
}

