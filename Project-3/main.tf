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



//Resource group

module "rg" {
  source        = "../Project-2-module/resource-group"
  resource_name = var.resource_name
  location      = var.location
}

//virtual network

module "vnet" {
  source        = "../Project-2-module/vnet"
  for_each      = var.vnet
  vnet_name     = each.key
  resource_name = module.rg.resource_name
  location      = module.rg.location
  address_space = each.value.address_space
  subnets       = each.value.subnets

  depends_on = [module.rg]
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
  subnet_id = module.vnet["project3_vnet"].subnet_id[local.subnet_ids[each.value.subnet_id]]
  nsg_id    = module.nsg[each.key].nsg_id
}


// route-table

module "route_table" {
  source           = "../Project-2-module/route-table"
  for_each         = var.route_tables
  route_table_name = each.key
  resource_name    = module.rg.resource_name
  location         = module.rg.location
  depends_on       = [module.rg, module.vnet, module.nsg]
}

// subnet associate routetable

module "sub-to-route-associate" {
  source         = "../Project-2-module/route-table-associate"
  for_each       = var.subnet-to-route-associate
  subnet_id      = module.vnet["project3_vnet"].subnet_id[local.subnet_ids[each.value.subnet_id]]
  route_table_id = module.route_table[each.key].route_table_id
}
