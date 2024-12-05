variable "vnet_name" {
  description = "The name of the Virtual Network"
  type        = string
}

variable "location" {
  description = "The location/region for the VNet"
  type        = string
}

variable "resource_name" {
  description = "The name of the Resource Group"
  type        = string
}

variable "address_space" {
  description = "The address space for the VNet"
  type        = list(string)
}

# variable "subnets" {
#   description = "List of subnets"
#   type = list(object({
#     name           = string
#     address_prefix = string
#   }))
# }
