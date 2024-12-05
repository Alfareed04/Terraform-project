output "rg" {
  value = azurerm_resource_group.rg
}

output "vnets" {
  value = azurerm_virtual_network.vnet
}

output "subnets" {
  value = azurerm_subnet.subnets
}