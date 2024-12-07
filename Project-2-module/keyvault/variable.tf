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