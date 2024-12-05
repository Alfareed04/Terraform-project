variable "subnets" {
  type = map(object({
    subnet_name = string
    address_prefix = string
  }))
}

variable "appgw-subnet" {
  type = map(object({
    subnet_name = string
    address_prefix = string
  }))
}

variable "dns_name" {
  type = string
}

variable "dns_link_name" {
  type = string
}

variable "dns_record_name" {
  type = string
}

variable "user_assigned_identity_name" {
  type = string
}