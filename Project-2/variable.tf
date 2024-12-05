variable "resource_name" {
  type = string
  description = "This is Module Resource group"
}

variable "location" {
  type = string
  description = "This is Location"
}

variable "vnets" {

type = map(object({
  name = string
  address_space = string
})) 
}

variable "subnets" {
  type = map(object({
    subnet_name = string
    address_prefix = string
  }))
}

variable "nsg_name" {
  type = string
}

variable "nsg_config" {
  type = map(object({
    nsg_name       = string
    security_rules = list(object({
      name                       = string
      priority                   = number
      direction                  = string
      access                     = string
      protocol                   = string
      source_port_range          = string
      destination_port_ranges    = list(string)
      source_address_prefix      = string
      destination_address_prefix = string
    }))
  }))
}

variable "routetable_name" {
  type = string
}
