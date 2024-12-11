variable "keyvault_name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_name" {
  type = string
}

variable "sku_name" {
  type = string
}

variable "tenant_id" {
  type = string
}

variable "purge_protection_enabled" {
  type = bool
}

variable "soft_delete_retention_days" {
  type = number
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