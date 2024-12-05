<!-- BEGIN_TF_DOCS -->
### Consume Modules to Create (VNET, Subnet, Resource Group, NSG, Route Table)

#### Project Overview:

This project uses Terraform to automate the creation and configuration of a secure and scalable network architecture on Microsoft Azure. By utilizing modular Terraform design, the project ensures a reusable, organized, and efficient infrastructure setup.

#### Key Components:

##### Resource Group (RG):
Creates a logical container for Azure resources to manage and organize them effectively.

##### Virtual Network (VNet):
Provisions multiple VNets, each with configurable address spaces and linked to the Resource Group.

##### Subnets:
Configures network segmentation by defining subnets within VNets, ensuring proper isolation and address allocation.

##### Network Security Groups (NSG):
Establishes security boundaries by creating NSGs for controlling inbound and outbound traffic.

##### NSG Rules:
Implements granular traffic control by defining custom security rules for each NSG.

##### NSG-to-Subnet Association:
Associates NSGs with specific subnets to enforce traffic control policies.

##### Route Tables:
Configures custom routing rules to manage traffic flow within and across subnets.

##### Route Table-to-Subnet Association:
Links route tables to subnets, enabling optimized traffic routing.

#### Highlights:

<b>Modular Design:</b> Reusable modules for Resource Groups, VNets, Subnets, NSGs, and Route Tables.

<b>Scalable Infrastructure:</b> Supports dynamic provisioning using variables and for\_each.

<b>Security Focused:</b> Granular NSG rules and route configurations for controlled access and traffic management.

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

//Resource group

module "rg" {
  source        = "../Project-2-module/resource-group"
  resource_name = var.resource_name
  location      = var.location
}

//virtual network

module "vnet" {
  source        = "../Project-2-module/vnet"
  for_each = var.vnet
  vnet_name = each.key
  resource_name = module.rg.resource_name
  location = module.rg.location
  address_space = [each.value.address_space]

  depends_on = [ module.rg ]
}

//subnet

module "subnets" {
  source         = "../Project-2-module/subnet"
  for_each       = var.subnets
  subnet_name    = each.value.subnet_name
  address_prefix = each.value.address_prefix
  resource_name  = module.rg.resource_name
  virtual_name   = module.vnet["project3_vnet"].name

  depends_on = [module.rg, module.vnet]
}

// nsg

module "nsg" {
  source         = "../Project-2-module/nsg"
  for_each       = var.nsg_config
  nsg_name       = each.value.nsg_name
  resource_name  = module.rg.resource_name
  location       = module.rg.location 
  security_rules = each.value.security_rules

  depends_on = [module.rg, module.vnet]
}

//nsg associate subnet

module "nsg-associate-to-sub" {
  source    = "../Project-2-module/nsg-associate"
  for_each  = var.subnet-to-nsg-associate
  subnet_id = module.subnets[each.value.subnet_id].id
  nsg_id    = module.nsg[each.key].nsg_id
}


// route-table

module "route_table" {
  source           = "../Project-2-module/route-table"
  for_each         = var.route_tables
  route_table_name = each.key
  resource_name    = module.rg.resource_name
  location         = module.rg.location
  depends_on       = [module.rg, module.vnet, module.subnets, module.nsg]
}

// subnet associate routetable

module "sub-to-route-associate" {
  source         = "../Project-2-module/route-table-associate"
  for_each       = var.subnet-to-route-associate
  subnet_id      = module.subnets[each.value.subnet_id].id
  route_table_id = module.route_table[each.key].route_table_id
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

Description: n/a

Type: `string`

### <a name="input_nsg"></a> [nsg](#input\_nsg)

Description: n/a

Type:

```hcl
map(object({
    nsg_name    = string
  }))
```

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

### <a name="input_resource_name"></a> [resource\_name](#input\_resource\_name)

Description: n/a

Type: `string`

### <a name="input_route_tables"></a> [route\_tables](#input\_route\_tables)

Description: n/a

Type:

```hcl
map(object({
    route_table_name = string
  }))
```

### <a name="input_subnet-to-nsg-associate"></a> [subnet-to-nsg-associate](#input\_subnet-to-nsg-associate)

Description: n/a

Type:

```hcl
map(object({
    subnet_id = string
  }))
```

### <a name="input_subnet-to-route-associate"></a> [subnet-to-route-associate](#input\_subnet-to-route-associate)

Description: n/a

Type:

```hcl
map(object({
    subnet_id = string
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

### <a name="input_vnet"></a> [vnet](#input\_vnet)

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

### <a name="module_nsg-associate-to-sub"></a> [nsg-associate-to-sub](#module\_nsg-associate-to-sub)

Source: ../Project-2-module/nsg-associate

Version:

### <a name="module_rg"></a> [rg](#module\_rg)

Source: ../Project-2-module/resource-group

Version:

### <a name="module_route_table"></a> [route\_table](#module\_route\_table)

Source: ../Project-2-module/route-table

Version:

### <a name="module_sub-to-route-associate"></a> [sub-to-route-associate](#module\_sub-to-route-associate)

Source: ../Project-2-module/route-table-associate

Version:

### <a name="module_subnets"></a> [subnets](#module\_subnets)

Source: ../Project-2-module/subnet

Version:

### <a name="module_vnet"></a> [vnet](#module\_vnet)

Source: ../Project-2-module/vnet

Version:

Automating secure and scalable Azure network infrastructure with Terraform modules.
<!-- END_TF_DOCS -->