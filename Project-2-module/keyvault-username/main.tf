resource "azurerm_key_vault_secret" "admin_username" {
  name = var.username
  value = var.value
  key_vault_id = var.key_vault_id
}