output "load_balancer" {
  value = azurerm_lb.load_balancer
}

output "id" {
  value = azurerm_lb.load_balancer.id
}

# output "backend_address_pool_id" {
#   value = azurerm_lb.load_balancer.
# }