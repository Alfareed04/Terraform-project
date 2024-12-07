# variable "resource_name" {
#   type = string
# }

# variable "resource_location" {
#   type = string
# }

variable "subnets" {
  type = map(object({
    subnet_name = string
    address_prefix = string
  }))
}

variable "virtual_machine_name" {
  type = string
}

variable "os_disk_name" {
  type = string
}

variable "disk_encryption_name" {
  type = string
}

variable "nic_name" {
  type = string
}

variable "keyvault_name" {
  type = string
}

# variable "admin_username" {
#   type = string
# }

# variable "admin_password" {
#   type = string
# }

# variable "key_name" {
#    type = string
#  }

variable "public_ip_name" {
  type = string
}

variable "load_balancer_name" {
  type = string
}

variable "storage_account_name" {
  type = string
}

variable "user_assigned_identity_name" {
  type = string
}

variable "disk_name" {
  type = string
}

variable "access_policies" {
  type = list(object({
    tenant_id               = string
    object_id               = string
    secret_permissions      = list(string)
    certificate_permissions = list(string)
    key_permissions         = list(string)
  }))
}

variable "keys" {
  type = list(object({
    name      = string
    key_type  = string
    key_size  = number
    key_opts  = list(string)
  }))
}

variable "secrets" {
  type = list(object({
    name  = string
    value = string
  }))
}

variable "frontend_ip_configurations" {
  type = list(object({
    name                          = string
    subnet_id                     = string
    private_ip_address_allocation = string
  }))
  description = "List of frontend IP configurations"
}

variable "backend_address_pools" {
  type = list(object({
    name = string
  }))
  description = "List of backend address pools"
}

variable "probes" {
  type = list(object({
    name     = string
    protocol = string
    port     = number
  }))
  description = "List of health probes"
}

variable "rules" {
  type = list(object({
    name                           = string
    frontend_ip_configuration_name = string
    backend_address_pool_id        = string
    protocol                       = string
    frontend_port                  = number
    backend_port                   = number
    probe_id                       = string
  }))
  description = "List of load balancing rules"
}
