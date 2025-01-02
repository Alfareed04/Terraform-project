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

module "rg" {
  source        = "../Project-2-module/resource-group"
  resource_name = var.resource_name
  location      = var.location
}

# module "vnet" {
#   source        = "../Project-2-module/vnet"
#   for_each      = var.vnets
#   vnet_name     = each.key
#   address_space = [each.value.address_space]
#   location      = module.rg.location
#   resource_name = module.rg.resource_name
#   depends_on    = [module.rg]
# }

module "vnet" {
  source        = "../Project-2-module/vnet"
  for_each      = var.vnets
  vnet_name     = each.key
  resource_name = module.rg.resource_name
  location      = module.rg.location
  address_space = each.value.address_space
  subnets       = each.value.subnets

  depends_on = [module.rg]
}

# module "subnet" {
#   source         = "../Project-2-module/subnet"
#   for_each       = var.subnets
#   subnet_name    = each.value.subnet_name
#   address_prefix = each.value.address_prefix
#   resource_name  = module.rg.resource_name
#   virtual_name   = module.vnet["project2_vnet"].name
#   depends_on     = [module.rg, module.vnet]
# }

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
