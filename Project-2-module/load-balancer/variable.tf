variable "load_balancer_name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_name" {
  type = string
}

variable "sku" {
  type = string
}

variable "frontend_ip_configurations" {
  type = list(object({
    name                          = string
    subnet_id                     = string
    private_ip_address_allocation = string
  }))
}

variable "backend_address_pools" {
  type = list(object({
    name = string
  }))
}

variable "probes" {
  type = list(object({
    name     = string
    protocol = string
    port     = number
  }))
}

variable "rules" {
  type = list(object({
    name                           = string
    frontend_ip_configuration_name = string
    backend_address_pool_id        = string
    protocol                       = string
    frontend_port                  = number
    backend_port                   = number
    probe_id                       = string
  }))
}
