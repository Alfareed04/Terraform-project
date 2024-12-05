output "kv_private_endpoint" {
  value = azurerm_private_endpoint.kv_private_endpoint
}

output "name" {
  value = azurerm_private_endpoint.kv_private_endpoint.name
}

output "id" {
  value = azurerm_private_endpoint.kv_private_endpoint.id
}

output "resource_name" {
  value = azurerm_private_endpoint.kv_private_endpoint.resource_group_name
}

output "private_service_connection_id" {
  value = azurerm_private_endpoint.kv_private_endpoint.private_service_connection[0].private_ip_address
}