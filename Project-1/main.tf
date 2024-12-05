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

