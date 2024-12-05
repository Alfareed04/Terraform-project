# resource_name = "Project4-rg"
# resource_location = "East US"

subnets = {
  "subnet01" = {
    subnet_name = "subnet01"
    address_prefix = "10.2.5.0/24"
  },
  "subnet02" = {
    subnet_name = "subnet02"
    address_prefix = "10.2.6.0/24"
  }
}

virtual_machine_name = "project4-vm"
nic_name = "VM-nic"
keyvault_name = "vault-project04"
admin_password = "SecureP@ssw0rd188"
admin_username = "azureuser"
disk_encryption_name = "Diskencryption"
key_name = "keyvault-key"
os_disk_name = "VM-disk"
public_ip_name = "proj4-public-ip"
load_balancer_name = "proj4-lb"
storage_account_name = "prj4storage"
user_assigned_identity_name = "key-identity"
disk_name = "Disk"