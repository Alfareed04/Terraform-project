resource "azurerm_lb_rule" "example" {
  name                           = var.lb_rule_name
  loadbalancer_id                = var.loadbalancer_id
  frontend_ip_configuration_name = var.frontend_ip_configuration_name
  backend_address_pool_ids       = var.backend_address_pool_ids
  probe_id                       = var.probe_id
  protocol                       = var.protocol
  frontend_port                  = var.frontend_port
  backend_port                   = var.backend_port
}