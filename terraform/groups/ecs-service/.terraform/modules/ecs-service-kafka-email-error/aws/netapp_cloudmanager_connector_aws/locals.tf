locals {

  ingress_sgs = length(var.ingress_security_group_ids) >= 1 ? setproduct(var.ingress_security_group_ids, var.ingress_ports) : []
  egress_sgs  = length(var.egress_security_group_ids) >= 1 ? setproduct(var.egress_security_group_ids, var.egress_ports) : []

  netapp_cvo_accountIds = var.netapp_cvo_accountIds == null ? [data.aws_caller_identity.current.account_id] : var.netapp_cvo_accountIds
}