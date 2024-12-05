variable "keyvault_name" {
  type = string
}

variable "location" {
  type        = string
}

variable "resource_name" {
  type        = string
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

variable "access_policy_tenant_id" {
  type = string
}

variable "access_policy_object_id" {
  type = string
}

variable "access_policy_secret_permissions" {
  type = list(string)
}

variable "access_policy_key_permissions" {
  type = list(string)
}

variable "certificate_permissions" {
  type = list(string)
}