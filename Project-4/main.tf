terraform {
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
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

# // projct3 resources

# data "azurerm_resource_group" "rg" {
#   name = "Project3-rg"
# }

# // project3 vnet

# data "azurerm_virtual_network" "vnet" {
#   name = "project3_vnet"
#   resource_group_name = "Project3-rg"

#   depends_on = [ data.azurerm_resource_group.rg ]
# }

// create subnet

module "subnets" {
  source = "../Project-2-module/subnet"
  for_each = var.subnets
  subnet_name = each.key
  address_prefix = each.value.address_prefix
  resource_name = local.vnet[each.key].resource_group_name
  virtual_name = local.vnet[each.key].name

  depends_on = [ local.rg, local.vnet ]
}

//Keyvault 

data "azurerm_client_config" "current" {}
data "azuread_client_config" "current" {}

# module "keyvault" {
#   source = "../Project-2-module/keyvault"
#   keyvault_name = var.keyvault_name
#   resource_name = data.azurerm_resource_group.rg.name
#   location = data.azurerm_resource_group.rg.location
#   sku_name                    = "standard"
#   tenant_id                   = data.azurerm_client_config.current.tenant_id
#   purge_protection_enabled    = true
#   soft_delete_retention_days = 30
#   access_policy_tenant_id = data.azurerm_client_config.current.tenant_id
#   access_policy_object_id = data.azuread_client_config.current.object_id
#   access_policy_secret_permissions = [ 
#       "Get",
#       "Set",
#       "Backup",
#       "Delete",
#       "Purge", 
#       "List",
#       "Recover",
#       "Restore"  
#   ]

#   certificate_permissions = [
#       "Get",
#       "List",
#       "Create",
#       "Delete",
#       "Update",
#       "Import",
#       "ManageContacts",
#       "ManageIssuers",
#       "Purge",
#       "Recover"
#     ]

#   access_policy_key_permissions = [
#       "Get",
#       "Encrypt",
#       "Backup",
#       "Delete",
#       "Purge", 
#       "List",
#       "Recover",
#       "Restore",
#       "Create"
#   ]

# }

# module "admin_username" {
#   source = "../Project-2-module/keyvault-username"
#   username = "keyvault-username"
#   value = var.admin_username
#   key_vault_id = module.keyvault.id
#   depends_on = [ module.keyvault ]
# }

# module "admin_password" {
#   source = "../Project-2-module/keyvault-password"
#   password = "keyvault-password"
#   value = var.admin_password
#   key_vault_id = module.keyvault.id
#   depends_on = [ module.admin_username ]
# }

# module "keyvault_key" {
#   source = "../Project-2-module/keyvault-key"
#   key_name = var.key_name
#   key_vault_id = module.keyvault.id
#   key_type     = "RSA"
#   key_size     = 2048
#   key_opts     = ["encrypt", "decrypt"] 
#   depends_on = [ module.keyvault]
# }

module "keyvault" {
  source = "../Project-2-module/keyvault"
  keyvault_name = var.keyvault_name
  resource_name = local.rg.name
  location = local.rg.location
  sku_name                    = "standard"
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  purge_protection_enabled    = true
  soft_delete_retention_days = 30
  access_policies = var.access_policies
  keys = var.keys
  secrets = var.secrets

  depends_on = [ local.rg, local.vnet ]
}

module "keyvault_user_assigned_identity" {
  source = "../Project-2-module/user-assigned-identity"
  user_assigned_identity_name = var.user_assigned_identity_name
  resource_name = local.rg.name
  location = local.rg.location

  depends_on = [ local.rg, module.keyvault ]
}

module "keyvault_access_policy" {
  source = "../Project-2-module/keyvault-policy"
  keyvault_id = module.keyvault.id
  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = module.keyvault_user_assigned_identity.id
  key_permissions = ["Get", "WrapKey", "UnwrapKey"] 
  certificate_permissions = ["Get", "List"]
  secret_permissions      = ["Get", "List"]
  depends_on = [ module.keyvault, module.keyvault_user_assigned_identity ]

}

//Disk
module "disk" {
  source = "../Project-2-module/disk"
  disk_name            = var.disk_name
  location             = local.rg.location
  resource_name        = local.rg.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 30

  depends_on = [ local.rg ]
}

// Disk encryption

module "disk_encryption" {
  source = "../Project-2-module/disk-encryption"
  disk_encryption_name = var.disk_encryption_name
  resource_name = local.rg.name
  location = local.rg.location
  keyvault_key_id = module.keyvault_key.id

  depends_on = [ module.keyvault, module.keyvault_key ]
}

// Disk attach vm
module "disk_attach_vm" {
  source = "../Project-2-module/disk-attach"
  managed_disk_id = module.disk.id
  virtual_machine_id = module.virtual_machine.id
  lun = 0
  caching = "Readwrite"

  depends_on = [ module.disk, module.virtual_machine ]
}

//load balancer

module "load_balancer" {
  source = "../Project-2-module/load-balancer"
  load_balancer_name = var.load_balancer_name
  resource_name = local.rg.name
  location = local.rg.location
  sku = "Standard"
  frontend_ip_configurations = var.frontend_ip_configurations
  probes = var.probes
  rules = var.rules
  backend_address_pools = var.backend_address_pools

  depends_on = [ local.rg, module.subnets ]
}

# //backendpool

# module "lb_backend_pool" {
#   source = "../Project-2-module/lb_backendpool"
#   backend_pool_name = "proj4-backend-pool"
#   loadbalancer_id = module.load_balancer.id

#   depends_on = [ module.load_balancer ]
# }

# //lb health probe

# module "lb_health_probe" {
#   source = "../Project-2-module/lb-health-probe"
#   lb_probe_name = "proj4-probe"
#   resource_name = local.rg.name
#   loadbalancer_id = module.load_balancer.id
#   protocol = "Tcp"
#   port = 80

#   depends_on = [ module.load_balancer ]
# }

# // lb rule

# module "lb_rule" {
#   source = "../Project-2-module/lb-rule"
#   lb_rule_name = "proj4-lbrule"
#   resource_name = local.rg.name
#   loadbalancer_id = module.load_balancer.id
#   frontend_ip_configuration_name = "proj4-frontend-ip"
#   backend_address_pool_ids = [ module.lb_backend_pool.id ]
#   probe_id = module.lb_health_probe.id
#   protocol = "Tcp"
#   frontend_port = 80
#   backend_port = 80

#   depends_on = [ data.azurerm_resource_group.rg, module.load_balancer, module.lb_backend_pool, module.lb_health_probe ]
# }

//storage account

module "storage_account" {
  source = "../Project-2-module/storage-account"
  storage_account_name = var.storage_account_name
  resource_name = local.rg.name
  location = local.rg.location
  account_tier = "Standard"
  account_replication_type = "LRS"

  depends_on = [ local.rg ]
}


//Network interface ( nic ) 
module "nic" {
  source = "../Project-2-module/nic"
  nic_name = var.nic_name
  resource_name = local.rg.name
  location = local.rg.location
  ip_configuration_name = "internal"
  subnet_id = module.subnets["subnet01"].id
  private_ip_address_allocation = "Dynamic"

  depends_on = [ local.rg, module.subnets ]
}

// Associate backendpool to nic
module "nic_associate" {
  source = "../Project-2-module/backend-pool-associate"
  network_interface_id = module.nic.id
  backend_address_pool_id = module.keyvault.l
  ip_configuration_name = "internal"

  depends_on = [ module.keyvault, module.nic ]
}

// create vm

module "virtual_machine" {
source = "../Project-2-module/virtual-machine"
vm_name = var.virtual_machine_name
resource_name = local.rg.name
location = local.rg.location
vm_size = "Standard_D2s_V3"
admin_username = module.keyvault.secrets.value
admin_password = module.keyvault.secrets.value
network_interface_ids = [ module.nic.id ]
os_disk_name = var.os_disk_name
os_disk_caching            = "ReadWrite"
os_disk_storage_account_type = "Premium_LRS"
disk_encryption_set_id     = module.disk_encryption.id
image_publisher            = "MicrosoftWindowsServer"
image_offer                = "windowsServer"
image_sku                  = "2022-datacenter-azure-edition"
image_version              = "latest"


depends_on = [ local.rg, module.keyvault, module.nic,
module.disk_encryption ]
}