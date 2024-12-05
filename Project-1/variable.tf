variable "resource_group_name" {
    type = string
    description = "This is Resource group name"
}

variable "resource_group_location" {
  type = string
  description = "This is Resource group location"
}

variable "vnets" {
  type = map(object({
    vnet_name = string
    address_space = string
  }))
  description = "Map of virtual network details"
}

variable "subnets" {
  type = map(object({
    subnet_name = string
    address_prefix = string
  }))
  description = "Map of subnet configurations"
}
