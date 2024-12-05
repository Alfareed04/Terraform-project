variable "resource_name" {
  type = string
}

variable "location" {
  type = string
}

variable "vnet" {

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

variable "nsg" {
  type = map(object({
    nsg_name    = string
  }))
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

variable "subnet-to-nsg-associate" {
  type = map(object({
    subnet_id = string
  }))
}

variable "route_tables" {
  type = map(object({
    route_table_name = string
  }))
}

variable "subnet-to-route-associate" {
  type = map(object({
    subnet_id = string
  }))
}
