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

// create subnet

module "subnets" {
  source         = "../Project-2-module/subnet"
  for_each       = var.subnets
  subnet_name    = each.key
  address_prefix = each.value.address_prefix
  resource_name  = local.vnet["Project3-vnet"].resource_group_name
  virtual_name   = local.vnet["Project3-vnet"].name

  depends_on = [local.rg, local.vnet]
}

//Keyvault 

data "azurerm_client_config" "current" {}
data "azuread_client_config" "current" {}

module "keyvault" {
  source                     = "../Project-2-module/keyvault"
  keyvault_name              = var.keyvault_name
  resource_name              = local.rg.name
  location                   = local.rg.location
  sku_name                   = "standard"
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  purge_protection_enabled   = true
  soft_delete_retention_days = 30
  access_policies            = var.access_policies
  key_name                   = var.key_name
  key_type                   = var.key_type
  key_size                   = var.key_size
  key_opts                   = var.key_opts
  admin_username             = var.admin_username
  admin_value                = var.admin_value
  admin_password             = var.admin_password
  password_value             = var.password_value

  depends_on = [local.rg, local.vnet]
}

module "keyvault_user_assigned_identity" {
  source                      = "../Project-2-module/user-assigned-identity"
  user_assigned_identity_name = var.user_assigned_identity_name
  resource_name               = local.rg.name
  location                    = local.rg.location

  depends_on = [local.rg, module.keyvault]
}

module "keyvault_access_policy" {
  source                  = "../Project-2-module/keyvault-policy"
  keyvault_id             = module.keyvault.id
  tenant_id               = data.azurerm_client_config.current.tenant_id
  object_id               = module.keyvault_user_assigned_identity.id
  key_permissions         = ["Get", "WrapKey", "UnwrapKey"]
  certificate_permissions = ["Get", "List"]
  secret_permissions      = ["Get", "List"]
  depends_on              = [module.keyvault, module.keyvault_user_assigned_identity]

}

//Disk
module "disk" {
  source               = "../Project-2-module/disk"
  disk_name            = var.disk_name
  location             = local.rg.location
  resource_name        = local.rg.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 30

  depends_on = [local.rg]
}

// Disk encryption

module "disk_encryption" {
  source               = "../Project-2-module/disk-encryption"
  disk_encryption_name = var.disk_encryption_name
  resource_name        = local.rg.name
  location             = local.rg.location
  keyvault_key_id      = module.keyvault.key_id

  depends_on = [module.keyvault]
}

// Disk attach vm
module "disk_attach_vm" {
  source             = "../Project-2-module/disk-attach"
  managed_disk_id    = module.disk.id
  virtual_machine_id = module.virtual_machine.id
  lun                = 0
  caching            = "Readwrite"

  depends_on = [module.disk, module.virtual_machine]
}

//load balancer

module "load_balancer" {
  source                         = "../Project-2-module/load-balancer"
  load_balancer_name             = var.load_balancer_name
  resource_name                  = local.rg.name
  location                       = local.rg.location
  sku                            = "Standard"
  frontend_ip_configurations     = var.frontend_ip_configurations
  backend_name                   = var.backend_name
  lb_probe_name                  = var.lb_probe_name
  protocol                       = var.protocol
  port                           = var.port
  lb_rule_name                   = var.lb_rule_name
  frontend_ip_configuration_name = var.frontend_ip_configuration_name
  rule_protocol                  = var.rule_protocol
  frontend_port                  = var.frontend_port
  backend_port                   = var.backend_port

  depends_on = [local.rg, module.subnets]
}

//storage account

module "storage_account" {
  source                   = "../Project-2-module/storage-account"
  storage_account_name     = var.storage_account_name
  resource_name            = local.rg.name
  location                 = local.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  depends_on = [local.rg]
}


//Network interface ( nic ) 
module "nic" {
  source                        = "../Project-2-module/nic"
  nic_name                      = var.nic_name
  resource_name                 = local.rg.name
  location                      = local.rg.location
  ip_configuration_name         = "internal"
  subnet_id                     = module.subnets["subnet01"].id
  private_ip_address_allocation = "Dynamic"

  depends_on = [local.rg, module.subnets]
}

// Associate backendpool to nic
module "nic_associate" {
  source                  = "../Project-2-module/backend-pool-associate"
  network_interface_id    = module.nic.id
  backend_address_pool_id = module.load_balancer.backendpool_id
  ip_configuration_name   = "internal"

  depends_on = [module.keyvault, module.nic]
}

// create vm

module "virtual_machine" {
  source                       = "../Project-2-module/virtual-machine"
  vm_name                      = var.virtual_machine_name
  resource_name                = local.rg.name
  location                     = local.rg.location
  vm_size                      = "Standard_D2s_V3"
  admin_username               = module.keyvault.admin_username
  admin_password               = module.keyvault.admin_password
  network_interface_ids        = [module.nic.id]
  os_disk_name                 = var.os_disk_name
  os_disk_caching              = "ReadWrite"
  os_disk_storage_account_type = "Premium_LRS"
  disk_encryption_set_id       = module.disk_encryption.id
  image_publisher              = "MicrosoftWindowsServer"
  image_offer                  = "windowsServer"
  image_sku                    = "2022-datacenter-azure-edition"
  image_version                = "latest"


  depends_on = [local.rg, module.keyvault, module.nic,
  module.disk_encryption]
}
