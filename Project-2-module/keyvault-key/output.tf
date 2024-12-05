output "keyvault_key" {
  value = azurerm_key_vault_key.keyvault_key
}

output "key_name" {
  value = azurerm_key_vault_key.keyvault_key.name
}

output "id" {
  value = azurerm_key_vault_key.keyvault_key.id
}