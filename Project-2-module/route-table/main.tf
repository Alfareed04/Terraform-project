resource "azurerm_route_table" "route-table" {
  name = var.route_table_name
  resource_group_name = var.resource_name
  location = var.location
}