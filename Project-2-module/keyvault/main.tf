resource "azurerm_key_vault" "Key_vault" {
  name                       = var.keyvault_name
  resource_group_name        = var.resource_name
  location                   = var.location
  sku_name                   = var.sku_name
  tenant_id                  = var.tenant_id
  purge_protection_enabled   = var.purge_protection_enabled
  soft_delete_retention_days = var.soft_delete_retention_days

  dynamic "access_policy" {
    for_each = var.access_policies
    content {
      tenant_id               = access_policy.value.tenant_id
      object_id               = access_policy.value.object_id
      secret_permissions      = access_policy.value.secret_permissions
      certificate_permissions = access_policy.value.certificate_permissions
      key_permissions         = access_policy.value.key_permissions
    }
  }
}

resource "azurerm_key_vault_key" "key" {
  name         = var.key_name
  key_vault_id = azurerm_key_vault.Key_vault.id
  key_type     = var.key_type
  key_size     = var.key_size

  key_opts = var.key_opts

}

resource "azurerm_key_vault_secret" "admin-username" {
  name         = var.admin_username
  value        = var.admin_value
  key_vault_id = azurerm_key_vault.Key_vault.id
}

resource "azurerm_key_vault_secret" "admin-password" {
  name         = var.admin_password
  value        = var.password_value
  key_vault_id = azurerm_key_vault.Key_vault.id
}