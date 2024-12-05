variable "lb_rule_name" {
  type = string
}

variable "resource_name" {
  type = string
}

variable "loadbalancer_id" {
  type = string
}

variable "frontend_ip_configuration_name" {
    type = string  
}

variable "backend_address_pool_ids" {
  type = list(string)
}

variable "probe_id" {
  type = string
}

variable "protocol" {
  type = string
}

variable "frontend_port" {
  type = number
}

variable "backend_port" {
  type = number
}