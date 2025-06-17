resource "aws_route53_zone" "this" {
  for_each = var.ignore_vpc_changes == false ? var.zones : {}

  name          = each.key
  comment       = lookup(each.value, "comment", null)
  force_destroy = lookup(each.value, "force_destroy", false)

  dynamic "vpc" {
    for_each = lookup(each.value, "vpc", {})
    content {
      vpc_id = vpc.value
    }
  }

  tags = merge(
    {
      "Terraform" = "true",
    },
    lookup(each.value, "tags", null)
  )
}

resource "aws_route53_zone" "this_lifecycle" {
  for_each = var.ignore_vpc_changes == true ? var.zones : {}

  name          = each.key
  comment       = lookup(each.value, "comment", null)
  force_destroy = lookup(each.value, "force_destroy", false)

  dynamic "vpc" {
    for_each = lookup(each.value, "vpc", {})
    content {
      vpc_id = vpc.value
    }
  }

  tags = merge(
    {
      "Terraform" = "true",
    },
    lookup(each.value, "tags", null)
  )

  lifecycle {
    ignore_changes = [
      vpc,
    ]
  }
}
