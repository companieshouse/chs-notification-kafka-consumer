provider "aws" {
}

resource "aws_vpc" "main" {
  cidr_block = "20.0.0.0/16"

  tags = {
    Name      = "example"
    Terraform = "true"
  }
}

module "subnets" {
  source = "../../multi_az_subnets"

  vpc_id   = aws_vpc.main.id
  networks = var.networks

  tags = {
    Terraform = "true"
  }
}
