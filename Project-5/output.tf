output "rg" {
  value = data.azurerm_resource_group.rg
}

output "vnet" {
  value = data.azurerm_virtual_network.vnet
}

output "subnet" {
  value = data.azurerm_subnet.subnet
}