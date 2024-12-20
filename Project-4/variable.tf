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

variable "key_name" {
  type = string
}

variable "key_type" {
  type = string
}

variable "key_size" {
  type = number
}

variable "key_opts" {
  type = list(string)
}

# variable "secrets" {
#   type = map(object({
#     name  = string
#     value = string
#   }))
# }

variable "admin_username" {
  type = string
}

variable "admin_value" {
  type = string
}

variable "admin_password" {
  type = string
}

variable "password_value" {
  type = string
}

variable "frontend_ip_configurations" {
  type = list(object({
    name                          = string
    subnet_id                     = string
    private_ip_address_allocation = string
  }))
  description = "List of frontend IP configurations"
}

variable "backend_name" {
  type = string
}

variable "lb_probe_name" {
  type = string
}

variable "protocol" {
  type = string
}

variable "port" {
  type = number
}

variable "lb_rule_name" {
  type = string
}

variable "frontend_ip_configuration_name" {
    type = string  
}

variable "rule_protocol" {
  type = string
}

variable "frontend_port" {
  type = number
}

variable "backend_port" {
  type = number
}

