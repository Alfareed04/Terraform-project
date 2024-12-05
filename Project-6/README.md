<!-- BEGIN_TF_DOCS -->


```hcl
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }
  required_version = ">= 1.1.0" // Create a Resource Group using Terraform

}

provider "azurerm" {
  features {}
}

// data block resources

data "azurerm_resource_group" "rg" {
  name = "Project3-rg"
}

// data block vnet

data "azurerm_virtual_network" "vnet" {
  name                = "project3_vnet"
  resource_group_name = "Project3-rg"

  depends_on = [data.azurerm_resource_group.rg]
}

// data block subnet

data "azurerm_subnet" "subnet" {
  for_each             = var.subnets
  name                 = each.key
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_virtual_network.vnet.resource_group_name

  depends_on = [data.azurerm_resource_group.rg, data.azurerm_virtual_network.vnet]
}

# Add a resource block to create a new subnet if required
module "firewall_subnet" {
  source         = "../Project-2-module/subnet"
  for_each       = var.firewall-subnet
  subnet_name    = each.key
  address_prefix = each.value.address_prefix
  virtual_name   = data.azurerm_virtual_network.vnet.name
  resource_name  = data.azurerm_virtual_network.vnet.resource_group_name

  depends_on = [data.azurerm_resource_group.rg, data.azurerm_virtual_network.vnet, data.azurerm_subnet.subnet]
}

// Firewall Public IP

module "Public_ip" {
  source            = "../Project-2-module/public-ip"
  public_ip_name    = "Firewall-pub-IP"
  resource_name     = data.azurerm_resource_group.rg.name
  location          = data.azurerm_resource_group.rg.location
  allocation_method = "Static"
  sku               = "Standard"

  depends_on = [data.azurerm_resource_group.rg]
}

// Firewall Policy

module "firewall_policy" {
  source               = "../Project-2-module/firewall-policy"
  firewall_policy_name = "firewall-policy"
  resource_name        = data.azurerm_resource_group.rg.name
  location             = data.azurerm_resource_group.rg.location
  sku                  = "Standard"

  depends_on = [data.azurerm_resource_group.rg, data.azurerm_virtual_network.vnet]
}

// Firewall

module "firewall" {
  source        = "../Project-2-module/firewall"
  firewall_name = "firewall"
  resource_name = module.firewall_policy.resource_name
  location      = module.firewall_policy.location
  sku_name      = "AZFW_VNet"
  sku_tier      = "Standard"

  ip_configuration_name = "firewallconfiguration"
  subnet_id             = module.firewall_subnet["AzureFirewallSubnet"].id
  public_ip_address_id  = module.Public_ip.id

  firewall_policy_id = module.firewall_policy.id

  depends_on = [data.azurerm_resource_group.rg, data.azurerm_virtual_network.vnet, data.azurerm_subnet.subnet,
  module.Public_ip, module.firewall_policy]
}

// Route Table

module "routetable" {
  source           = "../Project-2-module/route-table"
  route_table_name = var.route_table_name
  resource_name    = data.azurerm_resource_group.rg.name
  location         = data.azurerm_resource_group.rg.location
  depends_on       = [data.azurerm_resource_group.rg, data.azurerm_virtual_network.vnet]
}

// Route

module "firewall_route" {
  source                 = "../Project-2-module/route"
  route_name             = "route-to-firewall"
  resource_name          = module.routetable.resource_name
  location               = module.routetable.location
  route_table_name       = module.routetable.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = "10.2.8.4"

  depends_on = [module.firewall, module.routetable]
}

// Associate to routetable

module "ass_rt" {
  source         = "../Project-2-module/route-table-associate"
  subnet_id      = data.azurerm_subnet.subnet["subnet01"].id
  route_table_id = module.routetable.route_table_id

  depends_on = [data.azurerm_resource_group.rg, data.azurerm_subnet.subnet, module.routetable]
}


// nsg

module "nsg" {
  source        = "../Project-2-module/nsg"
  nsg_name      = var.nsg_name
  resource_name = data.azurerm_resource_group.rg.name
  location      = data.azurerm_resource_group.rg.location

  depends_on = [data.azurerm_resource_group.rg, data.azurerm_virtual_network.vnet]
}

//nsg-rule

module "nsg_rule" {
  source        = "../Project-2-module/nsg-rule"
  for_each      = var.security_rules
  nsg_name      = each.key
  resource_name = data.azurerm_resource_group.rg.name
  location      = data.azurerm_resource_group.rg.location

  name                       = each.value.name
  priority                   = each.value.priority
  direction                  = each.value.direction
  access                     = each.value.access
  protocol                   = each.value.protocol
  source_port_range          = each.value.source_port_range
  destination_port_range     = each.value.destination_port_ranges
  source_address_prefix      = each.value.source_address_prefix
  destination_address_prefix = each.value.destination_address_prefix

  depends_on = [module.nsg]
}

//nsg associate subnet

module "nsg-associate-to-sub" {
  source    = "../Project-2-module/nsg-associate"
  subnet_id = data.azurerm_subnet.subnet["subnet01"].id
  nsg_id    = module.nsg.nsg_id
}
```

<!-- markdownlint-disable MD033 -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.1.0)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 3.0.2)

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (~> 3.0.2)

## Resources

The following resources are used by this module:

- [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) (data source)
- [azurerm_subnet.subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) (data source)
- [azurerm_virtual_network.vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) (data source)

<!-- markdownlint-disable MD013 -->
## Required Inputs

The following input variables are required:

### <a name="input_firewall-subnet"></a> [firewall-subnet](#input\_firewall-subnet)

Description: n/a

Type:

```hcl
map(object({
    subnet_name = string
    address_prefix = string
  }))
```

### <a name="input_nsg_name"></a> [nsg\_name](#input\_nsg\_name)

Description: n/a

Type: `string`

### <a name="input_route_table_name"></a> [route\_table\_name](#input\_route\_table\_name)

Description: n/a

Type: `string`

### <a name="input_security_rules"></a> [security\_rules](#input\_security\_rules)

Description: n/a

Type:

```hcl
map(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_ranges     = list(string)
    source_address_prefix      = string
    destination_address_prefix = string
    nsg_name                   = string
   }))
```

### <a name="input_subnets"></a> [subnets](#input\_subnets)

Description: n/a

Type:

```hcl
map(object({
    subnet_name = string
    address_prefix = string
  }))
```

## Optional Inputs

No optional inputs.

## Outputs

No outputs.

## Modules

The following Modules are called:

### <a name="module_Public_ip"></a> [Public\_ip](#module\_Public\_ip)

Source: ../Project-2-module/public-ip

Version:

### <a name="module_ass_rt"></a> [ass\_rt](#module\_ass\_rt)

Source: ../Project-2-module/route-table-associate

Version:

### <a name="module_firewall"></a> [firewall](#module\_firewall)

Source: ../Project-2-module/firewall

Version:

### <a name="module_firewall_policy"></a> [firewall\_policy](#module\_firewall\_policy)

Source: ../Project-2-module/firewall-policy

Version:

### <a name="module_firewall_route"></a> [firewall\_route](#module\_firewall\_route)

Source: ../Project-2-module/route

Version:

### <a name="module_firewall_subnet"></a> [firewall\_subnet](#module\_firewall\_subnet)

Source: ../Project-2-module/subnet

Version:

### <a name="module_nsg"></a> [nsg](#module\_nsg)

Source: ../Project-2-module/nsg

Version:

### <a name="module_nsg-associate-to-sub"></a> [nsg-associate-to-sub](#module\_nsg-associate-to-sub)

Source: ../Project-2-module/nsg-associate

Version:

### <a name="module_nsg_rule"></a> [nsg\_rule](#module\_nsg\_rule)

Source: ../Project-2-module/nsg-rule

Version:

### <a name="module_routetable"></a> [routetable](#module\_routetable)

Source: ../Project-2-module/route-table

Version:

<!-- END_TF_DOCS -->