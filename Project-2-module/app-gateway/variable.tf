variable "appgw_name" {
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

variable "tier" {
  type = string
}

variable "capacity" {
  type = number
}

variable "type" {
  type = string
}

variable "identity_ids" {
  type = list(string)
}

variable "gateway_ip_configuration_name" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "frontend_ip_configuration_name" {
  type = string
}

variable "public_ip_address_id" {
  type = string
}

variable "frontend_port_name" {
  type = string
}

variable "port" {
  type = string
}

variable "backend_address_pool_name" {
  type = string
}

variable "backend_http_settings_name" {
  type = string
}

variable "cookie_based_affinity" {
  type = string
}

variable "backend_http_settings_port" {
  type = number
}

variable "protocol" {
  type = string
}

variable "request_timeout" {
  type = string
}

variable "http_listener_name" {
  type = string
}

variable "http_frontend_ip_configuration_name" {
  type = string
}

variable "http_listener_frontend_port_name" {
  type = string
}

variable "http_listener_protocol" {
  type = string
}

variable "ssl_certificate_name" {
  type = string
}

variable "key_vault_secret_id" {
  type = string
}

variable "request_routing_rule_name" {
  type = string
}

variable "rule_type" {
  type = string
}

variable "routing_http_listener_name" {
  type = string
}

variable "routing_backend_address_pool_name" {
  type = string
}

variable "routing_backend_http_settings_name" {
  type = string
}