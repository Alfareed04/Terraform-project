<!-- BEGIN_TF_DOCS -->
### Project 01: Basic Azure Resources Setup (VNET, Subnet, Resource Group, NSG, Route Table)

1. <b>Resource Group:</b> Creates an Azure resource group as a container for the resources.

2. <b>Virtual Network (VNet):</b> Creates multiple virtual networks based on the provided variable vnets, with address spaces and associations to the resource group.

3. <b>Subnets:</b> Creates subnets within a specified VNet using the subnets variable, and associates each with a unique address prefix.

4. <b>Route Table:</b> Creates a route table and associates it with subnets for custom routing.

5. <b>Route Table Association:</b> Associates the created route table with each subnet.

6. <b>Network Security Group (NSG):</b> Creates an NSG with security rules to allow inbound RDP (3389) and HTTP (80) traffic.

7. <b>NSG Association:</b> Associates the NSG with a specified subnet (in this case, "SubnetApp").

```hcl
// Resource Group

resource "azurerm_resource_group" "rg" {
  name = var.resource_group_name
  location = var.resource_group_location
}

//Virtual Network

resource "azurerm_virtual_network" "vnet" {
  for_each = var.vnets            
    name = each.key
    address_space = [each.value.address_space]
    resource_group_name = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location

    depends_on = [ azurerm_resource_group.rg ]
}

//Subnet

resource "azurerm_subnet" "subnets" {                        
  for_each = var.subnets
  name                 = each.key
  address_prefixes     = [each.value.address_prefix] 
  virtual_network_name = azurerm_virtual_network.vnet["project1_vnet"].name
  resource_group_name  = azurerm_resource_group.rg.name
  depends_on           = [azurerm_resource_group.rg, azurerm_virtual_network.vnet]
}


//Route Table

resource "azurerm_route_table" "routetable" {
  name                = "Project1-Routetable"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  depends_on = [ azurerm_resource_group.rg, azurerm_virtual_network.vnet, azurerm_subnet.subnets ]
}

//Associate route table
resource "azurerm_subnet_route_table_association" "associate_routetable" {
  for_each = local.subnets
  subnet_id      = azurerm_subnet.subnets[each.key].id
  route_table_id = azurerm_route_table.routetable.id
  depends_on = [ azurerm_subnet.subnets, azurerm_route_table.routetable ]
}

// Nsg

resource "azurerm_network_security_group" "nsg" {
  name                = "project1-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "Allow-RDP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"    # RDP
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-HTTP"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"      # HTTP
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

// Nsg associate to Subnet

resource "azurerm_subnet_network_security_group_association" "nsg_assoc" {
  subnet_id           = azurerm_subnet.subnets["SubnetApp"].id
  network_security_group_id = azurerm_network_security_group.nsg.id
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

- [azurerm_network_security_group.nsg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) (resource)
- [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) (resource)
- [azurerm_route_table.routetable](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route_table) (resource)
- [azurerm_subnet.subnets](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) (resource)
- [azurerm_subnet_network_security_group_association.nsg_assoc](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) (resource)
- [azurerm_subnet_route_table_association.associate_routetable](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_route_table_association) (resource)
- [azurerm_virtual_network.vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) (resource)

<!-- markdownlint-disable MD013 -->
## Required Inputs

The following input variables are required:

### <a name="input_resource_group_location"></a> [resource\_group\_location](#input\_resource\_group\_location)

Description: This is Resource group location

Type: `string`

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: This is Resource group name

Type: `string`

### <a name="input_subnets"></a> [subnets](#input\_subnets)

Description: Map of subnet configurations

Type:

```hcl
map(object({
    subnet_name = string
    address_prefix = string
  }))
```

### <a name="input_vnets"></a> [vnets](#input\_vnets)

Description: Map of virtual network details

Type:

```hcl
map(object({
    vnet_name = string
    address_space = string
  }))
```

## Optional Inputs

No optional inputs.

## Outputs

The following outputs are exported:

### <a name="output_rg"></a> [rg](#output\_rg)

Description: n/a

### <a name="output_subnets"></a> [subnets](#output\_subnets)

Description: n/a

### <a name="output_vnets"></a> [vnets](#output\_vnets)

Description: n/a

## Modules

No modules.

Automate Azure network setup with Terraform for efficient, secure, and scalable cloud infrastructure.
<!-- END_TF_DOCS -->