locals {

  name = var.name
  short_name = var.short_name

  tags = merge(var.tags, { "Terraform" = "true" })


  assume_role_account = var.connector_accountId == null ? data.aws_caller_identity.current.account_id : var.connector_accountId

  # See https://docs.netapp.com/us-en/occm/reference_security_groups.html#rules-for-cloud-volumes-ontap for port details
  # Initially leaving egress open as per netapp reccomendations, we can restrict this further after initial deploys if required.
  ingress_ports = [
    { "protocol" = "tcp", "port" = 80 },
    { "protocol" = "tcp", "port" = 443 },
    { "protocol" = "tcp", "port" = 22 },
    { "protocol" = "tcp", "port" = 111 },
    { "protocol" = "tcp", "port" = 139 },
    { "protocol" = "tcp", "port" = 161, "to_port" = 162 },
    { "protocol" = "tcp", "port" = 445 },
    { "protocol" = "tcp", "port" = 635 },
    { "protocol" = "tcp", "port" = 749 },
    { "protocol" = "tcp", "port" = 2049 },
    { "protocol" = "tcp", "port" = 3260 },
    { "protocol" = "tcp", "port" = 4045, "to_port" = 4046 },
    { "protocol" = "tcp", "port" = 10000 },
    { "protocol" = "tcp", "port" = 11104, "to_port" = 11105 },
    { "protocol" = "udp", "port" = 111 },
    { "protocol" = "udp", "port" = 161, "to_port" = 162 },
    { "protocol" = "udp", "port" = 635 },
    { "protocol" = "udp", "port" = 2049 },
    { "protocol" = "udp", "port" = 4045, "to_port" = 4046 },
    { "protocol" = "udp", "port" = 4049 },
  ]
  egress_ports = [
    { "protocol" = "-1", "port" = -1, "to_port" = -1 }
  ]

  ingress_sgs = length(var.ingress_security_group_ids) >= 1 ? setproduct(var.ingress_security_group_ids, local.ingress_ports) : []
}
