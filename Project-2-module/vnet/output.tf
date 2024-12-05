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

# output "subnet" {
#   value = azurerm_virtual_network.vnet.subnet
# }