variable "keyvault_id" {
  type = string
}

variable "tenant_id" {
  type = string
}

variable "object_id" {
  type = string
}

variable "secret_permissions" {
  type = list(string)
}

variable "key_permissions" {
  type = list(string)
}

variable "certificate_permissions" {
  type = list(string)
}