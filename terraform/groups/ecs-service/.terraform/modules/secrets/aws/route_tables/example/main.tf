provider "aws" {
}
### 
# This will create a Route Table and also test deployment of routes.
###
module "route_tables" {
  source = "../../route_tables"

  vpcID       = var.vpcID
  name        = var.name
  route_list  = var.route_list
  subnet_list = var.subnet_list
}