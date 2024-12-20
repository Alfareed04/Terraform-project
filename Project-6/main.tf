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
    storage_account_name = "backendstgconfig"
    container_name       = "container-config"
    key                  = "Terraform-project.tfstate"
  }
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
  source         = "../Project-2-module/nsg"
  for_each       = var.nsg_config
  nsg_name       = each.key
  resource_name  = data.azurerm_resource_group.rg.name
  location       = data.azurerm_resource_group.rg.location
  security_rules = each.value.security_rules

  depends_on = [data.azurerm_resource_group.rg, data.azurerm_virtual_network.vnet]
}

# //nsg-rule

# module "nsg_rule" {
#   source        = "../Project-2-module/nsg-rule"
#   for_each      = var.security_rules
#   nsg_name      = each.key
#   resource_name = data.azurerm_resource_group.rg.name
#   location      = data.azurerm_resource_group.rg.location

#   name                       = each.value.name
#   priority                   = each.value.priority
#   direction                  = each.value.direction
#   access                     = each.value.access
#   protocol                   = each.value.protocol
#   source_port_range          = each.value.source_port_range
#   destination_port_range     = each.value.destination_port_ranges
#   source_address_prefix      = each.value.source_address_prefix
#   destination_address_prefix = each.value.destination_address_prefix

#   depends_on = [module.nsg]
# }

//nsg associate subnet

module "nsg-associate-to-sub" {
  source    = "../Project-2-module/nsg-associate"
  subnet_id = data.azurerm_subnet.subnet["subnet01"].id
  nsg_id    = module.nsg.nsg_id
}
