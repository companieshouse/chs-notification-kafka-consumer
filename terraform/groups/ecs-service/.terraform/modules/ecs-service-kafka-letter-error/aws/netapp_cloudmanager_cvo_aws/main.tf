resource "netapp-cloudmanager_cvo_aws" "cvo_aws" {
  name = format("%s%s", "cvo", replace(local.name, "/[^a-z0-9+]+/", ""))

  region = data.aws_region.current.name

  ontap_version      = var.use_latest_version == true ? null : var.ontap_version
  use_latest_version = var.use_latest_version

  nss_account            = var.nss_account
  workspace_id           = var.workspace_id
  cloud_provider_account = var.cloud_provider_account
  client_id              = var.connector_client_id

  license_type                 = var.license_type
  is_ha                        = var.is_ha
  platform_serial_number       = var.is_ha ? null : var.platform_serial_numbers[0]
  platform_serial_number_node1 = var.is_ha ? var.platform_serial_numbers[0] : null
  platform_serial_number_node2 = var.is_ha ? var.platform_serial_numbers[1] : null

  backup_volumes_to_cbs         = false
  enable_compliance             = false
  enable_monitoring             = false
  optimized_network_utilization = true

  data_encryption_type = var.data_encryption_type
  ebs_volume_size      = var.ebs_volume_size
  ebs_volume_size_unit = var.ebs_volume_size_unit
  ebs_volume_type      = var.ebs_volume_type
  iops                 = var.iops
  throughput           = var.throughput
  capacity_tier        = var.capacity_tier
  tier_level           = var.tier_level

  svm_password           = var.svm_password
  vpc_id                 = var.vpc_id
  subnet_id              = var.is_ha ? null : element(var.subnet_ids, 0)
  node1_subnet_id        = var.is_ha ? element(var.subnet_ids, 0) : null
  node2_subnet_id        = var.is_ha ? element(var.subnet_ids, 1) : null
  mediator_subnet_id     = var.is_ha ? element(var.subnet_ids, 2) : null
  mediator_key_pair_name = var.is_ha ? var.mediator_key_pair_name : null
  instance_type          = var.instance_type

  failover_mode             = var.is_ha ? var.failover_mode : null
  cluster_floating_ip       = var.is_ha && var.failover_mode == "FloatingIP" ? var.cluster_floating_ips[0] : null
  svm_floating_ip           = var.is_ha && var.failover_mode == "FloatingIP" ? var.cluster_floating_ips[1] : null
  data_floating_ip          = var.is_ha && var.failover_mode == "FloatingIP" ? var.cluster_floating_ips[2] : null
  data_floating_ip2         = var.is_ha && var.failover_mode == "FloatingIP" ? var.cluster_floating_ips[3] : null
  mediator_assign_public_ip = var.is_ha ? false : null

  route_table_ids       = try(var.route_table_ids, null)
  instance_profile_name = aws_iam_instance_profile.this.name
  security_group_id     = aws_security_group.this.id

  dynamic "aws_tag" {
    for_each = merge(local.tags, { (var.managed_tag_key) = "True" })
    content {
      tag_key   = aws_tag.key
      tag_value = aws_tag.value
    }
  }
}

resource "aws_security_group" "this" {
  name        = format("%s-%s", "sgr", local.name)
  description = "Security group for Cloudmanager CVO instances."
  vpc_id      = var.vpc_id
  tags        = local.tags
}

resource "aws_security_group_rule" "internal" {
  description       = "Allow all traffic between members of this SG for inter node communications"
  security_group_id = aws_security_group.this.id
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  self              = true
}

resource "aws_security_group_rule" "ingress_cidrs" {
  count = length(var.ingress_cidr_blocks) >= 1 ? length(local.ingress_ports) : 0

  description       = "Allow ingress traffic on specified ports"
  security_group_id = aws_security_group.this.id
  type              = "ingress"
  from_port         = local.ingress_ports[count.index]["port"]
  to_port           = lookup(local.ingress_ports[count.index], "to_port", local.ingress_ports[count.index]["port"])
  protocol          = local.ingress_ports[count.index]["protocol"]
  cidr_blocks       = var.ingress_cidr_blocks
}

resource "aws_security_group_rule" "ingress_sgs" {
  count = length(local.ingress_sgs)

  description              = "Allow ingress traffic on specified ports"
  security_group_id        = aws_security_group.this.id
  type                     = "ingress"
  from_port                = local.ingress_sgs[count.index][1]["port"]
  to_port                  = lookup(local.ingress_sgs[count.index][1], "to_port", local.ingress_sgs[count.index][1]["port"])
  protocol                 = local.ingress_sgs[count.index][1]["protocol"]
  source_security_group_id = local.ingress_sgs[count.index][0]
}

resource "aws_security_group_rule" "egress_ports" {
  count = length(local.egress_ports)

  description       = "Allow egress traffic from CVO instances"
  security_group_id = aws_security_group.this.id
  type              = "egress"
  from_port         = local.egress_ports[count.index]["port"]
  to_port           = lookup(local.egress_ports[count.index], "to_port", local.egress_ports[count.index]["port"])
  protocol          = local.egress_ports[count.index]["protocol"]
  cidr_blocks       = var.egress_cidr_blocks #tfsec:ignore:AWS007
}
