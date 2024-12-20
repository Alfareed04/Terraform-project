output "load_balancer" {
  value = azurerm_lb.load_balancer
}

output "id" {
  value = azurerm_lb.load_balancer.id
}

output "backendpool_id" {
  value = azurerm_lb_backend_address_pool.backendpool.id
}

output "probe_id" {
  value = azurerm_lb_probe.lb_health_probe.id
}