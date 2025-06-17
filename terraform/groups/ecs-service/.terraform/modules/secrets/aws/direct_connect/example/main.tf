provider "aws" {
}

###
# Example minimal call of direct connect module. 
# This will create a Direct Connect gateway without any reliance on transit gateways or direct connect connections existing.
###
module "direct_connect" {
  source = "../."

  name            = var.name
  amazon_side_asn = var.amazon_side_asn
}
