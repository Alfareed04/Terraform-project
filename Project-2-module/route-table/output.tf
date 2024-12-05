output "route_table" {
  value = azurerm_route_table.route-table
}
output "route_table_id" {
  value = azurerm_route_table.route-table.id
}

output "name" {
  value = azurerm_route_table.route-table.name
}

output "resource_name" {
  value = azurerm_route_table.route-table.resource_group_name
}

output "location" {
  value = azurerm_route_table.route-table.location
}