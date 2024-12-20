output "vnet_name" {
  value = azurerm_virtual_network.vnet
}
output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}
output "name" {
  value = azurerm_virtual_network.vnet.name
}

# output "subnet_ids" {
#   value       = [for subnet in azurerm_virtual_network.vnet.subnet : subnet.id]
# }

output "subnet" {
  value = azurerm_subnet.subnet
}

# output "subnet_id" {
#   value = azurerm_subnet.subnet[each.key].id
# }

output "subnet_id" {
  value = [for subnet in azurerm_subnet.subnet : subnet.id]
}
