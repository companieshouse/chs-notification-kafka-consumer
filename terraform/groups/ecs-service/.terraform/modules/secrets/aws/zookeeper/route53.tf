resource "aws_route53_record" "zookeeper" {
  for_each = var.route53_available ? local.instance_definitions : {}

  zone_id = data.aws_route53_zone.zone[0].zone_id
  name    = each.value.hostname
  type    = "A"
  ttl     = "300"
  records = [aws_instance.zookeepers[each.key].private_ip]
}
