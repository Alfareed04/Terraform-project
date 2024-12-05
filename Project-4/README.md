<!-- BEGIN_TF_DOCS -->


```hcl
terraform {
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "~> 3.0.2"
    }
  }
  required_version = ">= 1.1.0"           // Create a Resource Group using Terraform

}
 
provider "azurerm" {
    features {}
}

// projct3 resources

data "azurerm_resource_group" "rg" {
  name = "Project3-rg"
}

// project3 vnet

data "azurerm_virtual_network" "vnet" {
  name = "project3_vnet"
  resource_group_name = "Project3-rg"

  depends_on = [ data.azurerm_resource_group.rg ]
}

// create subnet

# data "azurerm_subnet" "subnet" {
#   for_each = var.subnets
#   name = each.key
#   virtual_network_name = data.azurerm_virtual_network.vnet.name
#   resource_group_name = data.azurerm_virtual_network.vnet.resource_group_name
# }

module "subnets" {
  source = "../Project-2-module/subnet"
  for_each = var.subnets
  subnet_name = each.key
  address_prefix = each.value.address_prefix
  resource_name = data.azurerm_resource_group.rg.name
  virtual_name = data.azurerm_virtual_network.vnet.name

  depends_on = [ data.azurerm_resource_group.rg, data.azurerm_virtual_network.vnet ]
}

//Keyvault 

data "azurerm_client_config" "current" {}
data "azuread_client_config" "current" {}

module "keyvault" {
  source = "../Project-2-module/keyvault"
  keyvault_name = var.keyvault_name
  resource_name = data.azurerm_resource_group.rg.name
  location = data.azurerm_resource_group.rg.location
  sku_name                    = "standard"
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  purge_protection_enabled    = true
  soft_delete_retention_days = 30
  access_policy_tenant_id = data.azurerm_client_config.current.tenant_id
  access_policy_object_id = data.azuread_client_config.current.object_id
  access_policy_secret_permissions = [ 
      "Get",
      "Set",
      "Backup",
      "Delete",
      "Purge", 
      "List",
      "Recover",
      "Restore"  
  ]

  certificate_permissions = [
      "Get",
      "List",
      "Create",
      "Delete",
      "Update",
      "Import",
      "ManageContacts",
      "ManageIssuers",
      "Purge",
      "Recover"
    ]

  access_policy_key_permissions = [
      "Get",
      "Encrypt",
      "Backup",
      "Delete",
      "Purge", 
      "List",
      "Recover",
      "Restore",
      "Create"
  ]

}

module "admin_username" {
  source = "../Project-2-module/keyvault-username"
  username = "keyvault-username"
  value = var.admin_username
  key_vault_id = module.keyvault.id
  depends_on = [ module.keyvault ]
}

module "admin_password" {
  source = "../Project-2-module/keyvault-password"
  password = "keyvault-password"
  value = var.admin_password
  key_vault_id = module.keyvault.id
  depends_on = [ module.admin_username ]
}

module "keyvault_key" {
  source = "../Project-2-module/keyvault-key"
  key_name = var.key_name
  key_vault_id = module.keyvault.id
  key_type     = "RSA"
  key_size     = 2048
  key_opts     = ["encrypt", "decrypt"] 
  depends_on = [ module.keyvault]
}

module "keyvault_user_assigned_identity" {
  source = "../Project-2-module/user-assigned-identity"
  user_assigned_identity_name = var.user_assigned_identity_name
  resource_name = data.azurerm_resource_group.rg.name
  location = data.azurerm_resource_group.rg.location

  depends_on = [ data.azurerm_resource_group.rg, module.keyvault ]
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
  location             = data.azurerm_resource_group.rg.location
  resource_name        = data.azurerm_resource_group.rg.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 30

  depends_on = [ data.azurerm_resource_group.rg ]
}

// Disk encryption

module "disk_encryption" {
  source = "../Project-2-module/disk-encryption"
  disk_encryption_name = var.disk_encryption_name
  resource_name = data.azurerm_resource_group.rg.name
  location = data.azurerm_resource_group.rg.location
  keyvault_key_id = module.keyvault_key.id

  depends_on = [ module.keyvault, module.keyvault_key ]
}

// Disk attach vm
# module "disk_attach_vm" {
#   source = "../Project-2-module/disk-attach"
#   managed_disk_id = module.disk.id
#   virtual_machine_id = module.virtual_machine.id
#   lun = 0
#   caching = "Readwrite"

#   depends_on = [ module.disk, module.virtual_machine ]
# }

//load balancer

module "load_balancer" {
  source = "../Project-2-module/load-balancer"
  load_balancer_name = var.load_balancer_name
  location = data.azurerm_resource_group.rg.location
  resource_name = data.azurerm_resource_group.rg.name
  sku = "Standard"
  frontend_ip_name = "proj4-frontend-ip"
  subnet_id = module.subnets["subnet02"].id
  forntend_private_ip_address_allocation = "Dynamic"

  depends_on = [ data.azurerm_resource_group.rg, module.subnets ]
}

//backendpool

module "lb_backend_pool" {
  source = "../Project-2-module/lb_backendpool"
  backend_pool_name = "proj4-backend-pool"
  loadbalancer_id = module.load_balancer.id

  depends_on = [ module.load_balancer ]
}

//lb health probe

module "lb_health_probe" {
  source = "../Project-2-module/lb-health-probe"
  lb_probe_name = "proj4-probe"
  resource_name = data.azurerm_resource_group.rg.name
  loadbalancer_id = module.load_balancer.id
  protocol = "Tcp"
  port = 80

  depends_on = [ module.load_balancer ]
}

// lb rule

module "lb_rule" {
  source = "../Project-2-module/lb-rule"
  lb_rule_name = "proj4-lbrule"
  resource_name = data.azurerm_resource_group.rg.name
  loadbalancer_id = module.load_balancer.id
  frontend_ip_configuration_name = "proj4-frontend-ip"
  backend_address_pool_ids = [ module.lb_backend_pool.id ]
  probe_id = module.lb_health_probe.id
  protocol = "Tcp"
  frontend_port = 80
  backend_port = 80

  depends_on = [ data.azurerm_resource_group.rg, module.load_balancer, module.lb_backend_pool, module.lb_health_probe ]
}

//storage account

module "storage_account" {
  source = "../Project-2-module/storage-account"
  storage_account_name = var.storage_account_name
  location = data.azurerm_resource_group.rg.location
  resource_name = data.azurerm_resource_group.rg.name
  account_tier = "Standard"
  account_replication_type = "LRS"

  depends_on = [ data.azurerm_resource_group.rg ]
}


//Network interface ( nic ) 
module "nic" {
  source = "../Project-2-module/nic"
  nic_name = var.nic_name
  resource_name = data.azurerm_resource_group.rg.name
  location = data.azurerm_resource_group.rg.location
  ip_configuration_name = "internal"
  subnet_id = module.subnets["subnet01"].id
  private_ip_address_allocation = "Dynamic"

  depends_on = [ data.azurerm_resource_group.rg, module.subnets ]
}

// Associate backendpool to nic
module "nic_associate" {
  source = "../Project-2-module/backend-pool-associate"
  network_interface_id = module.nic.id
  backend_address_pool_id = module.lb_backend_pool.id
  ip_configuration_name = "internal"

  depends_on = [ module.lb_backend_pool, module.nic ]
}

# // create vm

# module "virtual_machine" {
# source = "../Project-2-module/virtual-machine"
# vm_name = var.virtual_machine_name
# resource_name = data.azurerm_resource_group.rg.name
# location = data.azurerm_resource_group.rg.location
# vm_size = "Standard_D2s_V3"
# admin_username = var.admin_username
# admin_password = var.admin_password
# network_interface_ids = [ module.nic.id ]
# os_disk_name = var.os_disk_name
# os_disk_caching            = "ReadWrite"
# os_disk_storage_account_type = "Premium_LRS"
# disk_encryption_set_id     = module.disk_encryption.id
# image_publisher            = "MicrosoftWindowsServer"
# image_offer                = "windowsServer"
# image_sku                  = "2022-datacenter-azure-edition"
# image_version              = "latest"


# depends_on = [ data.azurerm_resource_group.rg, module.keyvault, module.admin_username, module.admin_password, module.nic,
# module.disk_encryption ]
# }
```

<!-- markdownlint-disable MD033 -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.1.0)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 3.0.2)

## Providers

The following providers are used by this module:

- <a name="provider_azuread"></a> [azuread](#provider\_azuread)

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (~> 3.0.2)

## Resources

The following resources are used by this module:

- [azuread_client_config.current](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/client_config) (data source)
- [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) (data source)
- [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) (data source)
- [azurerm_virtual_network.vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) (data source)

<!-- markdownlint-disable MD013 -->
## Required Inputs

The following input variables are required:

### <a name="input_admin_password"></a> [admin\_password](#input\_admin\_password)

Description: n/a

Type: `string`

### <a name="input_admin_username"></a> [admin\_username](#input\_admin\_username)

Description: n/a

Type: `string`

### <a name="input_disk_encryption_name"></a> [disk\_encryption\_name](#input\_disk\_encryption\_name)

Description: n/a

Type: `string`

### <a name="input_disk_name"></a> [disk\_name](#input\_disk\_name)

Description: n/a

Type: `string`

### <a name="input_key_name"></a> [key\_name](#input\_key\_name)

Description: n/a

Type: `string`

### <a name="input_keyvault_name"></a> [keyvault\_name](#input\_keyvault\_name)

Description: n/a

Type: `string`

### <a name="input_load_balancer_name"></a> [load\_balancer\_name](#input\_load\_balancer\_name)

Description: n/a

Type: `string`

### <a name="input_nic_name"></a> [nic\_name](#input\_nic\_name)

Description: n/a

Type: `string`

### <a name="input_os_disk_name"></a> [os\_disk\_name](#input\_os\_disk\_name)

Description: n/a

Type: `string`

### <a name="input_public_ip_name"></a> [public\_ip\_name](#input\_public\_ip\_name)

Description: n/a

Type: `string`

### <a name="input_storage_account_name"></a> [storage\_account\_name](#input\_storage\_account\_name)

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

### <a name="input_user_assigned_identity_name"></a> [user\_assigned\_identity\_name](#input\_user\_assigned\_identity\_name)

Description: n/a

Type: `string`

### <a name="input_virtual_machine_name"></a> [virtual\_machine\_name](#input\_virtual\_machine\_name)

Description: n/a

Type: `string`

## Optional Inputs

No optional inputs.

## Outputs

The following outputs are exported:

### <a name="output_nic"></a> [nic](#output\_nic)

Description: n/a

### <a name="output_rg"></a> [rg](#output\_rg)

Description: n/a

### <a name="output_subnet"></a> [subnet](#output\_subnet)

Description: n/a

### <a name="output_vnet"></a> [vnet](#output\_vnet)

Description: n/a

## Modules

The following Modules are called:

### <a name="module_admin_password"></a> [admin\_password](#module\_admin\_password)

Source: ../Project-2-module/keyvault-password

Version:

### <a name="module_admin_username"></a> [admin\_username](#module\_admin\_username)

Source: ../Project-2-module/keyvault-username

Version:

### <a name="module_disk"></a> [disk](#module\_disk)

Source: ../Project-2-module/disk

Version:

### <a name="module_disk_encryption"></a> [disk\_encryption](#module\_disk\_encryption)

Source: ../Project-2-module/disk-encryption

Version:

### <a name="module_keyvault"></a> [keyvault](#module\_keyvault)

Source: ../Project-2-module/keyvault

Version:

### <a name="module_keyvault_access_policy"></a> [keyvault\_access\_policy](#module\_keyvault\_access\_policy)

Source: ../Project-2-module/keyvault-policy

Version:

### <a name="module_keyvault_key"></a> [keyvault\_key](#module\_keyvault\_key)

Source: ../Project-2-module/keyvault-key

Version:

### <a name="module_keyvault_user_assigned_identity"></a> [keyvault\_user\_assigned\_identity](#module\_keyvault\_user\_assigned\_identity)

Source: ../Project-2-module/user-assigned-identity

Version:

### <a name="module_lb_backend_pool"></a> [lb\_backend\_pool](#module\_lb\_backend\_pool)

Source: ../Project-2-module/lb_backendpool

Version:

### <a name="module_lb_health_probe"></a> [lb\_health\_probe](#module\_lb\_health\_probe)

Source: ../Project-2-module/lb-health-probe

Version:

### <a name="module_lb_rule"></a> [lb\_rule](#module\_lb\_rule)

Source: ../Project-2-module/lb-rule

Version:

### <a name="module_load_balancer"></a> [load\_balancer](#module\_load\_balancer)

Source: ../Project-2-module/load-balancer

Version:

### <a name="module_nic"></a> [nic](#module\_nic)

Source: ../Project-2-module/nic

Version:

### <a name="module_nic_associate"></a> [nic\_associate](#module\_nic\_associate)

Source: ../Project-2-module/backend-pool-associate

Version:

### <a name="module_storage_account"></a> [storage\_account](#module\_storage\_account)

Source: ../Project-2-module/storage-account

Version:

### <a name="module_subnets"></a> [subnets](#module\_subnets)

Source: ../Project-2-module/subnet

Version:

<!-- END_TF_DOCS -->