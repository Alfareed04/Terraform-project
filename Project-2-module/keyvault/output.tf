output "keyvault_name" {
  value = azurerm_key_vault.Key_vault.name
}

output "keyvault" {
  value = azurerm_key_vault.Key_vault
}

output "id" {
  value = azurerm_key_vault.Key_vault.id
}

output "key_id" {
  value = azurerm_key_vault_key.key.id
}

output "admin_username" {
  value = azurerm_key_vault_secret.admin-username.value
}

output "admin_password" {
  value = azurerm_key_vault_secret.admin-password.value
}
