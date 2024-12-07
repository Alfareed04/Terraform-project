# resource "azurerm_lb" "load_balancer" {
#   name                = var.load_balancer_name
#   location            = var.location
#   resource_group_name = var.resource_name
#   sku                 = var.sku

#   frontend_ip_configuration {
#     name                 = var.frontend_ip_name
#     subnet_id            = var.subnet_id
#     private_ip_address_allocation = var.forntend_private_ip_address_allocation
#   }
  
# }


resource "azurerm_lb" "load_balancer" {
  name                = var.load_balancer_name
  location            = var.location
  resource_group_name = var.resource_name
  sku                 = var.sku

  dynamic "frontend_ip_configuration" {
    for_each = var.frontend_ip_configurations
    content {
      name                              = frontend_ip_configuration.value.name
      subnet_id                         = frontend_ip_configuration.value.subnet_id
      private_ip_address_allocation     = frontend_ip_configuration.value.private_ip_address_allocation
    }
  }

  dynamic "backend_address_pool" {
    for_each = var.backend_address_pools
    content {
      name = backend_address_pool.value.name
    }
  }

  dynamic "probe" {
    for_each = var.probes
    content {
      name     = probe.value.name
      protocol = probe.value.protocol
      port     = probe.value.port
    }
  }

  dynamic "rule" {
    for_each = var.rules
    content {
      name                           = rule.value.name
      frontend_ip_configuration_name = rule.value.frontend_ip_configuration_name
      backend_address_pool_id        = rule.value.backend_address_pool_id
      protocol                       = rule.value.protocol
      frontend_port                  = rule.value.frontend_port
      backend_port                   = rule.value.backend_port
      probe_id                       = rule.value.probe_id
    }
  }
}

