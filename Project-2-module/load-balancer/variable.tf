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

variable "backend_name" {
  type = string
}

variable "lb_probe_name" {
  type = string
}

variable "protocol" {
  type = string
}

variable "port" {
  type = number
}

variable "lb_rule_name" {
  type = string
}

variable "frontend_ip_configuration_name" {
    type = string  
}

variable "rule_protocol" {
  type = string
}

variable "frontend_port" {
  type = number
}

variable "backend_port" {
  type = number
}
