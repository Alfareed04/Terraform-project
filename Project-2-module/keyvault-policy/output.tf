output "keyvault_policy" {
  value = azurerm_key_vault_access_policy.keyvault_policy
}

output "id" {
  value = azurerm_key_vault_access_policy.keyvault_policy.id
}