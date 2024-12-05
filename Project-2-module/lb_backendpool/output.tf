output "backend_pool" {
  value = azurerm_lb_backend_address_pool.backend_pool
}

output "id" {
  value = azurerm_lb_backend_address_pool.backend_pool.id
}