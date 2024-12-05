resource "azurerm_application_gateway" "appGW" {
  name                = var.appgw_name
  resource_group_name = var.resource_name
  location = var.location
  sku {
    name     = var.name
    tier     = var.tier
    capacity = var.capacity
  } 
  
  identity {
    type         = var.type
    identity_ids = var.identity_ids
  }

  gateway_ip_configuration {
    name      = var.gateway_ip_configuration_name
    subnet_id = var.subnet_id
  }

  frontend_ip_configuration {
    name                 = var.frontend_ip_configuration_name
    public_ip_address_id = var.public_ip_address_id
  }

  frontend_port {
    name = var.frontend_port_name
    port = var.port
  }

  backend_address_pool {
    name = var.backend_address_pool_name
  }

  backend_http_settings {
    name                  = var.backend_http_settings_name
    cookie_based_affinity = var.cookie_based_affinity
    port                  = var.backend_http_settings_port
    protocol              = var.protocol
    request_timeout       = var.request_timeout
    
  }

  http_listener {
    name                           = var.http_listener_name
    frontend_ip_configuration_name = var.http_frontend_ip_configuration_name
    frontend_port_name             = var.http_listener_frontend_port_name
    protocol                       = var.http_listener_protocol
    ssl_certificate_name           = var.ssl_certificate_name
  }

  ssl_certificate {
    name                = var.ssl_certificate_name
    key_vault_secret_id = var.key_vault_secret_id
  }

  request_routing_rule {
    name                       = var.request_routing_rule_name
    rule_type                  = var.rule_type
    http_listener_name         = var.routing_http_listener_name
    backend_address_pool_name  = var.routing_backend_address_pool_name
    backend_http_settings_name = var.routing_backend_http_settings_name
  }
 }