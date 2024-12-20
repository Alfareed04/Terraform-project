# resource_name = "Project4-rg"
# resource_location = "East US"

subnets = {
  "subnet01" = {
    subnet_name    = "subnet01"
    address_prefix = "10.2.5.0/24"
  },
  "subnet02" = {
    subnet_name    = "subnet02"
    address_prefix = "10.2.6.0/24"
  }
}

virtual_machine_name = "project4-vm"
nic_name             = "VM-nic"

keyvault_name = "KV-proj4"
access_policies = [
  {
    tenant_id = "data.azurerm_client_config.current.tenant_id"
    object_id = "data.azuread_client_config.current.object_id"
    secret_permissions = [
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
    key_permissions = [
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
]


key_name = "keyvault-key"
key_type = "RSA"
key_size = 2048
key_opts = ["encrypt", "decrypt"]


admin_username = "admin-username"
admin_value = "azureuser"
admin_password = "admin-password"
password_value = "SecureP@ssw0rd400"

# secrets = {
#   "admin-password" = {
#     name  = "admin-password"
#     value = "SecureP@ssw0rd188"
#   },

#  "admin-username" =  {
#     name  = "admin-username"
#     value = "azureuser"
#   }
# }

public_ip_name     = "proj4-public-ip"
load_balancer_name = "proj4-lb"

frontend_ip_configurations = [
  {
    name                          = "frontend-ip-1"
    subnet_id                     = "module.subnets[subnet02].id"
    private_ip_address_allocation = "Dynamic"
  }
]

backend_name = "BackEndpool"
lb_probe_name = "lb-probe"
protocol = "Tcp"
port = 80
lb_rule_name = "lb-rule"
frontend_ip_configuration_name = "proj4-frontend-ip"
rule_protocol = "Tcp"
frontend_port = 80
backend_port = 80

disk_encryption_name        = "Diskencryption"
os_disk_name                = "VM-disk"
storage_account_name        = "prj4storage"
user_assigned_identity_name = "key-identity"
disk_name                   = "Disk"
