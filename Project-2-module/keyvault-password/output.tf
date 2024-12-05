output "password" {
  value = azurerm_key_vault_secret.admin_password.name
}

output "value" {
  value = azurerm_key_vault_secret.admin_password.value
}