# az-vnet-peering

## Overview

This module will allow 2 vNets to be peered together to allow communications between networks.
The options allow for remote gateways to be used for external Azure connections as well as locking down traffic flow if required.

## Usage

```hcl
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

module "local" {
  source  = "Azure/vnet/azurerm"
  version = "2.3.0"

  resource_group_name = azurerm_resource_group.main.name
  vnet_name           = "${azurerm_resource_group.main.name}-local-vnet"
  address_space       = ["10.10.0.0/16"]
  subnet_prefixes     = ["10.10.1.0/27", "10.10.2.0/24"]
  subnet_names        = ["Subnet1", "Subnet2"]

  tags = {
    Terratest = "True"
  }

  depends_on = [azurerm_resource_group.main]
}

module "remote" {
  source  = "Azure/vnet/azurerm"
  version = "2.3.0"

  resource_group_name = azurerm_resource_group.main.name
  vnet_name           = "${azurerm_resource_group.main.name}-remote-vnet"
  address_space       = ["10.20.0.0/16"]
  subnet_prefixes     = ["10.20.1.0/27", "10.20.2.0/24"]
  subnet_names        = ["Subnet3", "Subnet4"]

  tags = {
    Terratest = "True"
  }

  depends_on = [azurerm_resource_group.main]
}


module "vnet_peer" {
  source = "../../az-vnet-peering"

  local_resource_group_name   = azurerm_resource_group.main.name
  local_virtual_network_name  = module.local.vnet_name
  remote_resource_group_name  = azurerm_resource_group.main.name
  remote_virtual_network_name = module.remote.vnet_name
  vnet_peer_config            = local.vnet_peer

  tags = merge(
    local.default_tags,
    map("peer", local.vnet_peer.peer_name)
  )

  depends_on = [azurerm_resource_group.main]
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13, < 0.14 |
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
| [azurerm_virtual_network_peering.local](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_peering) | resource |
| [azurerm_virtual_network_peering.remote](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_peering) | resource |
| [azurerm_resource_group.local](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_resource_group.remote](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_virtual_network.local](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) | data source |
| [azurerm_virtual_network.remote](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_local_resource_group_name"></a> [local\_resource\_group\_name](#input\_local\_resource\_group\_name) | The resource group name this virtual network will be created in | `string` | n/a | yes |
| <a name="input_local_virtual_network_name"></a> [local\_virtual\_network\_name](#input\_local\_virtual\_network\_name) | The virtual network name this virtual network gateway will be created in | `string` | n/a | yes |
| <a name="input_remote_resource_group_name"></a> [remote\_resource\_group\_name](#input\_remote\_resource\_group\_name) | The resource group name this virtual network will be created in | `string` | n/a | yes |
| <a name="input_remote_virtual_network_name"></a> [remote\_virtual\_network\_name](#input\_remote\_virtual\_network\_name) | The virtual network name this virtual network gateway will be created in | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | The tags to be applied to this resource | `map(any)` | <pre>{<br>  "Terraform": "True"<br>}</pre> | no |
| <a name="input_vnet_peer_config"></a> [vnet\_peer\_config](#input\_vnet\_peer\_config) | An object variable that consists of the relevant information to create a virtual network peering connection | <pre>object({<br>    peer_name = string,<br>    local = object({<br>      allow_virtual_network_access = bool,<br>      allow_forwarded_traffic      = bool,<br>      allow_gateway_transit        = bool,<br>      use_remote_gateways          = bool<br>    }),<br>    remote = object({<br>      allow_virtual_network_access = bool,<br>      allow_forwarded_traffic      = bool,<br>      allow_gateway_transit        = bool,<br>      use_remote_gateways          = bool<br>    })<br>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vnet_peering_local"></a> [vnet\_peering\_local](#output\_vnet\_peering\_local) | n/a |
| <a name="output_vnet_peering_remote"></a> [vnet\_peering\_remote](#output\_vnet\_peering\_remote) | n/a |
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
go test
```



## Authors

This project is authored by below people

- Martin Fox

> This project was generated by [generator-tf-module](https://github.com/sudokar/generator-tf-module)
