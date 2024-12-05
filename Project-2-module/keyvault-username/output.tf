output "username" {
  value = azurerm_key_vault_secret.admin_username.name
}

output "value" {
  value = azurerm_key_vault_secret.admin_username.value
}