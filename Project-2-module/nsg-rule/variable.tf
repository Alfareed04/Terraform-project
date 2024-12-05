variable "nsg_name" {
  type = string
}

variable "resource_name" {
  type = string
}

variable "location" {
  type = string
}

variable "name" {
  type = string
}

variable "priority" {
  type = number
}

variable "direction" {
  type = string
}

variable "access" {
  type = string
}

variable "protocol" {
  type = string
}

variable "source_port_range" {
  type = string
}

variable "destination_port_range" {
  type = list(string)
}

variable "source_address_prefix" {
  type = string
}

variable "destination_address_prefix" {
  type = string
}

