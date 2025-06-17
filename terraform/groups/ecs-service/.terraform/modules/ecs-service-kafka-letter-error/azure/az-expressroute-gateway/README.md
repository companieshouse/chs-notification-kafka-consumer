# az-expressroute-gateway

## Overview

This module will create the components required to setup an ExpressRoute Gateway in Azure.
You can choose to create only the Express Route Gateway type Virtual Network Gateway by setting the create_circuit option to false

## Usage

```hcl
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
  subnet_names        = ["GatewaySubnet"]

  tags = {
    Terratest = "True"
  }

  depends_on = [ azurerm_resource_group.example ]
}

module "expressroute" {
  source = "../../az-expressroute-gateway"

  resource_group_name   = azurerm_resource_group.example.name
  virtual_network_name  = module.vnet.vnet_name

  name                        = "${azurerm_resource_group.example.name}-exproute"
  expressroute_active_active  = false
  expressroute_enable_bgp    = false
  expressroute_vpn_sku        = "Standard"


  create_circuit = true
  circuit_service_provider = "vodafone"
  circuit_peering_location = "London"
  circuit_bandwidth_in_mbps = 50
  gateway_connection_enable_bgp = false

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
| [azurerm_express_route_circuit.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/express_route_circuit) | resource |
| [azurerm_express_route_circuit_authorization.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/express_route_circuit_authorization) | resource |
| [azurerm_express_route_circuit_peering.example](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/express_route_circuit_peering) | resource |
| [azurerm_public_ip.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_virtual_network_gateway.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_gateway) | resource |
| [azurerm_virtual_network_gateway_connection.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_gateway_connection) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_circuit_bandwidth_in_mbps"></a> [circuit\_bandwidth\_in\_mbps](#input\_circuit\_bandwidth\_in\_mbps) | A number for the bandwith required for this Express Route Circuit. *Once you increase your bandwidth, you will not be able to decrease it to its previous value* | `number` | `50` | no |
| <a name="input_circuit_peer_asn"></a> [circuit\_peer\_asn](#input\_circuit\_peer\_asn) | ASN Number for the peering, not the customer ASN | `string` | `null` | no |
| <a name="input_circuit_peer_primary_address_prefix"></a> [circuit\_peer\_primary\_address\_prefix](#input\_circuit\_peer\_primary\_address\_prefix) | Subnet range to be used as the primary prefix in the circuit peering | `string` | `null` | no |
| <a name="input_circuit_peer_secondary_address_prefix"></a> [circuit\_peer\_secondary\_address\_prefix](#input\_circuit\_peer\_secondary\_address\_prefix) | Subnet range to be used as the secondary prefix in the circuit peering | `string` | `null` | no |
| <a name="input_circuit_peering_location"></a> [circuit\_peering\_location](#input\_circuit\_peering\_location) | The name of the peering location and not the Azure resource location. Depends on the provider chosen and its available locations | `string` | `null` | no |
| <a name="input_circuit_service_provider"></a> [circuit\_service\_provider](#input\_circuit\_service\_provider) | The name of the Express Route Service Provider. | `string` | `null` | no |
| <a name="input_circuit_shared_key"></a> [circuit\_shared\_key](#input\_circuit\_shared\_key) | An optional Shared Key that can be used to setup the circuit and peering | `string` | `null` | no |
| <a name="input_circuit_sku_family"></a> [circuit\_sku\_family](#input\_circuit\_sku\_family) | The billing mode for bandwidth. Possible values are MeteredData or UnlimitedData. *You can migrate from MeteredData to UnlimitedData, but not the other way around.* | `string` | `"MeteredData"` | no |
| <a name="input_circuit_sku_tier"></a> [circuit\_sku\_tier](#input\_circuit\_sku\_tier) | The service tier. Possible values are Basic, Local, Standard or Premium. | `string` | `"Basic"` | no |
| <a name="input_circuit_vlanid"></a> [circuit\_vlanid](#input\_circuit\_vlanid) | The Vlan Id that relates to the provisioned circuits from the provider | `string` | `null` | no |
| <a name="input_create_circuit"></a> [create\_circuit](#input\_create\_circuit) | a True/False value to allow for option to build or not build the Express route Circuit | `bool` | `false` | no |
| <a name="input_create_gateway"></a> [create\_gateway](#input\_create\_gateway) | A True/False value to allow for option to build or not build the Express route gateway | `bool` | `false` | no |
| <a name="input_existing_vgw_id"></a> [existing\_vgw\_id](#input\_existing\_vgw\_id) | The Id for an existing Gateway to connect the circuit to if built. | `string` | `null` | no |
| <a name="input_expressroute_public_ip_sku"></a> [expressroute\_public\_ip\_sku](#input\_expressroute\_public\_ip\_sku) | SKU to use for the public IP, Basic or Standard | `string` | `"Basic"` | no |
| <a name="input_expressroute_vpn_sku"></a> [expressroute\_vpn\_sku](#input\_expressroute\_vpn\_sku) | Configuration of the size and capacity of the virtual network gateway. Valid options for Express Route are Standard, HighPerformance, UltraPerformance, ErGw1AZ, ErGw2AZ, ErGw3AZ. | `string` | `"Standard"` | no |
| <a name="input_gateway_connection_enable_bgp"></a> [gateway\_connection\_enable\_bgp](#input\_gateway\_connection\_enable\_bgp) | Boolean to enable BGP on the Express Route connection | `bool` | `false` | no |
| <a name="input_location"></a> [location](#input\_location) | Azure Region to deploy the express route components | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name to use for Express Route resources created (will be joined with other values to make names more useful) | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The resource group name this Express Route will be created in | `string` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | The subnetId for the GatewaySubnet the ExpressRoute Gateway will be created in | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | The tags to be applied to this resource | `map(any)` | <pre>{<br>  "Terraform": "True"<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_expressroute_circuit"></a> [expressroute\_circuit](#output\_expressroute\_circuit) | n/a |
| <a name="output_expressroute_circuit_connection_auth"></a> [expressroute\_circuit\_connection\_auth](#output\_expressroute\_circuit\_connection\_auth) | n/a |
| <a name="output_expressroute_gateway"></a> [expressroute\_gateway](#output\_expressroute\_gateway) | n/a |
| <a name="output_expressroute_gateway_connection"></a> [expressroute\_gateway\_connection](#output\_expressroute\_gateway\_connection) | n/a |
| <a name="output_public_ip"></a> [public\_ip](#output\_public\_ip) | n/a |
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
