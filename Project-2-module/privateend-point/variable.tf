variable "private_endpoint_name" {
  type = string
}

variable "resource_name" {
  type = string
}

variable "location" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "private_service_connection_name" {
  type = string
}

variable "private_connection_resource_id" {
  type = string
}

variable "is_manual_connection" {
  type = bool
}

variable "subresource_names" {
  type = list(string)
}