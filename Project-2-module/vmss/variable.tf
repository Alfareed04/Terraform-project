variable "vmss_name" {
  type = string
}

variable "resource_name" {
  type = string
}

variable "location" {
  type = string
}

variable "sku" {
  type = string
}

variable "instances" {
  type = number
}

variable "image_publisher" {
  type = string
}

variable "image_offer" {
  type = string
}

variable "image_sku" {
  type = string
}

variable "image_version" {
  type = string
}

variable "nic_name" {
  type = string
}

variable "nic_primary" {
  type = bool
}

variable "ip_configuration_name" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "application_gateway_backend_address_pool_ids" {
  type = list(string)
}

variable "os_caching" {
  type = string
}

variable "storage_account_type" {
  type = string
}

variable "type" {
  type = string
}

variable "identity_ids" {
  type = list(string)
}

variable "admin_username" {
  type = string
}

variable "admin_password" {
  type = string
}