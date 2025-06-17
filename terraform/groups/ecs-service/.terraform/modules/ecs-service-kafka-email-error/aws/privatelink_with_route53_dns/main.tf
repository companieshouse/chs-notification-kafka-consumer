data "aws_region" "current" {}

resource "aws_vpc_endpoint" "this" {
  vpc_endpoint_type   = "Interface"
  service_name        = format("com.amazonaws.%s.%s", data.aws_region.current.name, var.service_name)
  private_dns_enabled = var.private_dns_enabled

  vpc_id             = var.vpc_id
  security_group_ids = var.security_group_ids
  subnet_ids         = var.subnet_ids

  tags = merge(
    map(
      "Terraform", "true",
    ),
    var.tags,
  )

  timeouts {
    create = "20m"
    update = "20m"
    delete = "20m"
  }
}

resource "aws_route53_zone" "this" {
  count = var.private_dns_enabled == true ? 0 : 1

  name          = "${var.service_name}.${data.aws_region.current.name}.amazonaws.com"
  comment       = var.route53_comment
  force_destroy = var.route53_force_destroy

  vpc {
    vpc_id = var.vpc_id
  }

  tags = merge(
    map(
      "Terraform", "true",
    ),
    var.tags,
  )

  lifecycle {
    ignore_changes = [
      vpc,
    ]
  }
}

resource "aws_route53_record" "this" {
  count = var.private_dns_enabled == true ? 0 : 1

  zone_id = aws_route53_zone.this[0].zone_id
  name    = aws_route53_zone.this[0].name
  type    = "A"

  alias {
    name                   = aws_vpc_endpoint.this.dns_entry[0]["dns_name"]
    zone_id                = aws_vpc_endpoint.this.dns_entry[0]["hosted_zone_id"]
    evaluate_target_health = true
  }
}