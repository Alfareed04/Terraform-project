output "public_ip" {
  value = azurerm_public_ip.public_ip
}

output "id" {
  value = azurerm_public_ip.public_ip.id
}
