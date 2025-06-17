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
| [azurerm_public_ip.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_public_ip.this_active_active](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_virtual_network_gateway.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_gateway) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_subnet.gateway](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |
| [azurerm_virtual_network.vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_gateway"></a> [create\_gateway](#input\_create\_gateway) | A True/False value to allow for option to build or not build the Express route gateway | `bool` | `false` | no |
| <a name="input_enable_client_connections"></a> [enable\_client\_connections](#input\_enable\_client\_connections) | a True/False value to enable client connections for this VPN, allows for point to site connectivity | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | The name to use for Express Route resources created (will be joined with other values to make names more useful) | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The resource group name this Express Route will be created in | `string` | n/a | yes |
| <a name="input_revoked_certificate"></a> [revoked\_certificate](#input\_revoked\_certificate) | (Optional) Root certificates to revoke. This setting is incompatible with the use of aad\_tenant, aad\_audience, aad\_issuer, radius\_server\_address, and radius\_server\_secret. Each certificate should be listed as: [{ name = <name>, thumbprint = <The SHA1 thumbprint of the certificate to be revoked.>}] | `list(any)` | `null` | no |
| <a name="input_root_certificates"></a> [root\_certificates](#input\_root\_certificates) | (Optional) These root certificates are used to sign the client certificate used by the VPN clients to connect to the gateway. This setting is incompatible with the use of aad\_tenant, aad\_audience, aad\_issuer, radius\_server\_address, and radius\_server\_secret. Each certificate should be listed as: [{ name = <name>, cert\_data = <The public certificate of the root certificate authority. The certificate must be provided in Base-64 encoded X.509 format (PEM). In particular, this argument must not include the -----BEGIN CERTIFICATE----- or -----END CERTIFICATE----- markers.> }] | `list(any)` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | The tags to be applied to this resource | `map(any)` | <pre>{<br>  "Terraform": "True"<br>}</pre> | no |
| <a name="input_virtual_network_name"></a> [virtual\_network\_name](#input\_virtual\_network\_name) | The virtual network name this Express Route will be created in | `string` | n/a | yes |
| <a name="input_vpn_bgp_asn"></a> [vpn\_bgp\_asn](#input\_vpn\_bgp\_asn) | (Optional) The Autonomous System Number (ASN) to use as part of the BGP. | `string` | `null` | no |
| <a name="input_vpn_bgp_peer_weight"></a> [vpn\_bgp\_peer\_weight](#input\_vpn\_bgp\_peer\_weight) | (Optional) The weight added to routes which have been learned through BGP peering. Valid values can be between 0 and 100. | `number` | `null` | no |
| <a name="input_vpn_bgp_peering_addresses"></a> [vpn\_bgp\_peering\_addresses](#input\_vpn\_bgp\_peering\_addresses) | Optional) A list of peering\_addresses as defined below. Only one peering\_addresses block can be specified except when active\_active of this Virtual Network Gateway is true. | `list(any)` | `null` | no |
| <a name="input_vpn_client_aad_audience"></a> [vpn\_client\_aad\_audience](#input\_vpn\_client\_aad\_audience) | (Optional) The client id of the Azure VPN application. See https://docs.microsoft.com/en-gb/azure/vpn-gateway/openvpn-azure-ad-tenant-multi-app for values. This setting is incompatible with the use of root\_certificate and revoked\_certificate, radius\_server\_address, and radius\_server\_secret. | `string` | `null` | no |
| <a name="input_vpn_client_aad_issuer"></a> [vpn\_client\_aad\_issuer](#input\_vpn\_client\_aad\_issuer) | (Optional) The STS url for your tenant This setting is incompatible with the use of root\_certificate and revoked\_certificate, radius\_server\_address, and radius\_server\_secret. | `string` | `null` | no |
| <a name="input_vpn_client_aad_tenant"></a> [vpn\_client\_aad\_tenant](#input\_vpn\_client\_aad\_tenant) | (Optional) AzureAD Tenant URL This setting is incompatible with the use of root\_certificate and revoked\_certificate, radius\_server\_address, and radius\_server\_secret. | `string` | `null` | no |
| <a name="input_vpn_client_address_space"></a> [vpn\_client\_address\_space](#input\_vpn\_client\_address\_space) | (Required if client connections enabled) The address space out of which ip addresses for vpn clients will be taken. You can provide more than one address space, e.g. in CIDR notation. | `list(any)` | `null` | no |
| <a name="input_vpn_client_protocols"></a> [vpn\_client\_protocols](#input\_vpn\_client\_protocols) | (Optional) List of the protocols supported by the vpn client. The supported values are SSTP, IkeV2 and OpenVPN. Values SSTP and IkeV2 are incompatible with the use of aad\_tenant, aad\_audience and aad\_issuer. | `list(any)` | `null` | no |
| <a name="input_vpn_client_radius_server_address"></a> [vpn\_client\_radius\_server\_address](#input\_vpn\_client\_radius\_server\_address) | (Optional) The address of the Radius server. This setting is incompatible with the use of aad\_tenant, aad\_audience, aad\_issuer, root\_certificate and revoked\_certificate. | `string` | `null` | no |
| <a name="input_vpn_client_radius_server_secret"></a> [vpn\_client\_radius\_server\_secret](#input\_vpn\_client\_radius\_server\_secret) | (Optional) The secret used by the Radius server. This setting is incompatible with the use of aad\_tenant, aad\_audience, aad\_issuer, root\_certificate and revoked\_certificate. | `string` | `null` | no |
| <a name="input_vpn_enable_active_active"></a> [vpn\_enable\_active\_active](#input\_vpn\_enable\_active\_active) | a True/False value to enable Active:Active mode for the VPN | `bool` | `false` | no |
| <a name="input_vpn_enable_bgp"></a> [vpn\_enable\_bgp](#input\_vpn\_enable\_bgp) | a True/False value to enable BGP for the VPN | `bool` | `false` | no |
| <a name="input_vpn_public_ip_sku"></a> [vpn\_public\_ip\_sku](#input\_vpn\_public\_ip\_sku) | SKU to use for the public IP, Basic or Standard | `string` | `"Basic"` | no |
| <a name="input_vpn_sku"></a> [vpn\_sku](#input\_vpn\_sku) | (Required) Configuration of the size and capacity of the virtual network gateway. Valid options are Basic, Standard, HighPerformance, VpnGw1AZ, VpnGw2AZ, VpnGw3AZ,VpnGw4AZ and VpnGw5AZ and depend on the type, vpn\_type and generation arguments. A PolicyBased gateway only supports the Basic sku. | `string` | `"Standard"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_public_ip"></a> [public\_ip](#output\_public\_ip) | n/a |
| <a name="output_public_ip_active_active"></a> [public\_ip\_active\_active](#output\_public\_ip\_active\_active) | n/a |
| <a name="output_vpn_gateway"></a> [vpn\_gateway](#output\_vpn\_gateway) | n/a |
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
