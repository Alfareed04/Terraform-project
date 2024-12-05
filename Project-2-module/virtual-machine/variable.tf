variable "vm_name" {
  type        = string
}

variable "resource_name" {
  type        = string
}

variable "location" {
  type        = string
}

variable "vm_size" {
  type        = string
}

variable "admin_username" {
  type        = string
}

variable "admin_password" {
  type        = string
}

variable "network_interface_ids" {
  type        = list(string)
}

variable "os_disk_name" {
  type        = string
}

variable "os_disk_caching" {
  type        = string
}

variable "os_disk_storage_account_type" {
  type        = string
}

variable "disk_encryption_set_id" {
  type        = string
}

variable "image_publisher" {
  type        = string
}

variable "image_offer" {
  type        = string
}

variable "image_sku" {
  type        = string
}

variable "image_version" {
  type        = string
}
