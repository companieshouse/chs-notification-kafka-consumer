# az-expressroute-gateway

## Overview

This module will create the components required to setup an Azure Bastion including a public IP and Network Security Group.
The NSG has predefined rules as documented by Microsoft and must exist for the service to work: https://docs.microsoft.com/en-us/azure/bastion/bastion-nsg

## Usage

```hcl
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location
}

module "vnet" {
  source  = "Azure/vnet/azurerm"
  version = "2.3.0"

  resource_group_name = azurerm_resource_group.example.name
  vnet_name           = "${azurerm_resource_group.example.name}-vnet"
  address_space       = ["10.10.0.0/16"]
  subnet_prefixes     = ["10.10.1.0/27"]
  subnet_names        = ["AzureBastionSubnet"]

  tags = {
    Terratest = "True"
  }

  depends_on = [azurerm_resource_group.example]
}

module "bastion" {
  source = "../../az-bastion"

  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = module.vnet.vnet_name

  bastion_name  = "${azurerm_resource_group.example.name}-bastion"
  publicip_name = "${azurerm_resource_group.example.name}-pip-bastion"
  nsg_name      = "${azurerm_resource_group.example.name}-nsg-bastion"
  tags = {
    terratest = "true"
    testname  = var.resource_group_name
  }

  depends_on = [
    azurerm_resource_group.example,
    module.vnet
  ]
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.0, < 0.14 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 2.4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 2.4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_bastion_host.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/bastion_host) | resource |
| [azurerm_network_security_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_public_ip.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_subnet_network_security_group_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bastion_name"></a> [bastion\_name](#input\_bastion\_name) | The name for Bastion host | `string` | `"bastion-001"` | no |
| <a name="input_location"></a> [location](#input\_location) | Azure Region to deploy the Azure Bastion components | `string` | n/a | yes |
| <a name="input_nsg_name"></a> [nsg\_name](#input\_nsg\_name) | The name to give to the Azure Bastion Network Security Group | `string` | `"nsg-bastion-001"` | no |
| <a name="input_publicip_name"></a> [publicip\_name](#input\_publicip\_name) | The name for the Public IP for the Bastion | `string` | `"pip-bastion-001"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The resource group name this Azure Bastion will be created in | `string` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | The subnetId for the AzureBastionSubnet the Bastion will be created in | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | The tags to be applied to this resource | `map` | <pre>{<br>  "terraform": "true"<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bastion_host"></a> [bastion\_host](#output\_bastion\_host) | n/a |
| <a name="output_bastion_network_security_group"></a> [bastion\_network\_security\_group](#output\_bastion\_network\_security\_group) | n/a |
| <a name="output_bastion_public_ip"></a> [bastion\_public\_ip](#output\_bastion\_public\_ip) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Development

### Prerequisites

- [terraform](https://learn.hashicorp.com/terraform/getting-started/install#installing-terraform)
- [terraform-docs](https://github.com/segmentio/terraform-docs)
- [pre-commit](https://pre-commit.com/#install)
- [golang](https://golang.org/doc/install#install)
- [golint](https://github.com/golang/lint#installation)

### Configurations

- Configure pre-commit hooks
```sh
pre-commit install
```


- Configure golang deps for tests
```sh
> go get github.com/gruntwork-io/terratest/modules/terraform
> go get github.com/stretchr/testify/assert
```



### Tests

- Tests are available in `test` directory

- In the test directory, run the below command
```sh
go test -v ./ -timeout 100m
```



## Authors

This project is authored by below people

- Martin Fox

> This project was generated by [generator-tf-module](https://github.com/sudokar/generator-tf-module)
