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
}

resource "azurerm_lb_backend_address_pool" "backendpool" {
  loadbalancer_id = azurerm_lb.load_balancer.id
  name            = var.backend_name
}
  
resource "azurerm_lb_probe" "lb_health_probe" {
  name                = var.lb_probe_name
  loadbalancer_id     = azurerm_lb.load_balancer.id
  protocol            = var.protocol
  port                = var.port
} 

resource "azurerm_lb_rule" "lb_rule" {
  name                           = var.lb_rule_name
  loadbalancer_id                = azurerm_lb.load_balancer.id
  frontend_ip_configuration_name = var.frontend_ip_configuration_name
  backend_address_pool_ids       = azurerm_lb_backend_address_pool.backendpool.id
  probe_id                       = azurerm_lb_probe.lb_health_probe.id
  protocol                       = var.rule_protocol
  frontend_port                  = var.frontend_port
  backend_port                   = var.backend_port
}