output "appGW" {
  value = azurerm_application_gateway.appGW
}

output "id" {
  value = azurerm_application_gateway.appGW.id
}

output "backend_address_pool" {
  value = azurerm_application_gateway.appGW.backend_address_pool
}
