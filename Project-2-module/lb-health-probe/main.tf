resource "azurerm_lb_probe" "lb_health_probe" {
  name                = var.lb_probe_name
  loadbalancer_id     = var.loadbalancer_id
  protocol            = var.protocol
  port                = var.port
}