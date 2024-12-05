<!-- BEGIN_TF_DOCS -->
### Create Modules for Resource Providers

#### Project Overview:
The project leverages Terraform to create an Azure environment with a set of essential network resources. It involves the automation of resource group creation, virtual network (VNet) setup, subnets, network security groups (NSG), and route tables.

#### Key Components:
<b>Resource Group:</b> The project begins by defining a Resource Group using the azurerm provider. This is the logical container for all other Azure resources.

<b>Virtual Network (VNet):</b> Multiple VNets are created based on input variables, with each VNet having its own address space and location. Dependencies ensure they are created after the Resource Group.

<b>Subnets:</b> Subnets are defined within the VNets, with specific address prefixes, ensuring proper network segmentation.

<b>Network Security Group (NSG):</b> NSGs are set up to define rules for network traffic flow to protect resources within the VNets.

<b>NSG Rules:</b> Custom rules for the NSGs are created based on the configuration, defining traffic flow and security posture.

<b>Route Tables:</b> Route tables are configured to define the network routes for traffic between subnets and VNets.

#### Modules Used:

<b> Resource Group Module:</b> Responsible for resource group creation.

<b>VNet Module:</b> Sets up the virtual network with configurable address spaces.

<b>Subnet Module:</b> Creates subnets with specific IP address ranges.

<b>NSG Module:</b> Defines security group for controlling inbound and outbound traffic.

<b>NSG Rule Module:</b> Sets specific rules for network traffic control.

<b>Route Table Module:</b> Configures routing for the subnets.

### Conclusion:

This Terraform-based project automates the process of setting up a secure, scalable network architecture on Azure, streamlining the deployment of VNets, subnets, security groups, and routing tables. The use of modules enhances reusability and maintainability, making it easier to manage the resources as the project grows.

```hcl
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }
  required_version = ">= 1.1.0"


  backend "azurerm" {
    resource_group_name  = "backend_rg"
    storage_account_name = "stgacctconfig"
    container_name       = "container-config"
    key                  = "Terraform-project.tfstate"
  }
}

provider "azurerm" {
  features {}
}

module "rg" {
  source        = "../Project-2-module/resource-group"
  resource_name = var.resource_name
  location      = var.location
}

module "vnet" {
  source        = "../Project-2-module/vnet"
  for_each      = var.vnets
  vnet_name     = each.key
  address_space = [each.value.address_space]
  location      = module.rg.location
  resource_name = module.rg.resource_name
  depends_on    = [module.rg]
}

module "subnet" {
  source         = "../Project-2-module/subnet"
  for_each       = var.subnets
  subnet_name    = each.value.subnet_name
  address_prefix = each.value.address_prefix
  resource_name  = module.rg.resource_name
  virtual_name   = module.vnet["project2_vnet"].name
  depends_on     = [module.rg, module.vnet]
}

module "nsg" {
  source         = "../Project-2-module/nsg"
  for_each       = var.nsg_config
  nsg_name       = each.value.nsg_name
  resource_name  = module.rg.resource_name
  location       = module.rg.location
  security_rules = each.value.security_rules
}

module "routetable" {
  source           = "../Project-2-module/route-table"
  route_table_name = var.routetable_name
  resource_name    = module.rg.resource_name
  location         = module.rg.location
  depends_on       = [module.rg, module.vnet]
}
```

<!-- markdownlint-disable MD033 -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.1.0)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 3.0.2)

## Providers

No providers.

## Resources

No resources.

<!-- markdownlint-disable MD013 -->
## Required Inputs

The following input variables are required:

### <a name="input_location"></a> [location](#input\_location)

Description: This is Location

Type: `string`

### <a name="input_nsg_config"></a> [nsg\_config](#input\_nsg\_config)

Description: n/a

Type:

```hcl
map(object({
    nsg_name       = string
    security_rules = list(object({
      name                       = string
      priority                   = number
      direction                  = string
      access                     = string
      protocol                   = string
      source_port_range          = string
      destination_port_ranges    = list(string)
      source_address_prefix      = string
      destination_address_prefix = string
    }))
  }))
```

### <a name="input_nsg_name"></a> [nsg\_name](#input\_nsg\_name)

Description: n/a

Type: `string`

### <a name="input_resource_name"></a> [resource\_name](#input\_resource\_name)

Description: This is Module Resource group

Type: `string`

### <a name="input_routetable_name"></a> [routetable\_name](#input\_routetable\_name)

Description: n/a

Type: `string`

### <a name="input_subnets"></a> [subnets](#input\_subnets)

Description: n/a

Type:

```hcl
map(object({
    subnet_name = string
    address_prefix = string
  }))
```

### <a name="input_vnets"></a> [vnets](#input\_vnets)

Description: n/a

Type:

```hcl
map(object({
  name = string
  address_space = string
}))
```

## Optional Inputs

No optional inputs.

## Outputs

The following outputs are exported:

### <a name="output_rg"></a> [rg](#output\_rg)

Description: n/a

### <a name="output_subnet"></a> [subnet](#output\_subnet)

Description: n/a

### <a name="output_vnet"></a> [vnet](#output\_vnet)

Description: n/a

## Modules

The following Modules are called:

### <a name="module_nsg"></a> [nsg](#module\_nsg)

Source: ../Project-2-module/nsg

Version:

### <a name="module_rg"></a> [rg](#module\_rg)

Source: ../Project-2-module/resource-group

Version:

### <a name="module_routetable"></a> [routetable](#module\_routetable)

Source: ../Project-2-module/route-table

Version:

### <a name="module_subnet"></a> [subnet](#module\_subnet)

Source: ../Project-2-module/subnet

Version:

### <a name="module_vnet"></a> [vnet](#module\_vnet)

Source: ../Project-2-module/vnet

Version:

Terraform files for deploying resource groups, VNets, subnets, NSGs, and route tables in a scalable and secure architecture.
<!-- END_TF_DOCS -->