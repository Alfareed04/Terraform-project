resource "azurerm_lb_backend_address_pool" "backend_pool" {
  loadbalancer_id = var.loadbalancer_id
  name            = var.backend_pool_name
}