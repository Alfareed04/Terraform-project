resource "azurerm_key_vault_secret" "admin_password" {
  name = var.password
  value = var.value
  key_vault_id = var.key_vault_id
}