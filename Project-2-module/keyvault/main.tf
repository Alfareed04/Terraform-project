resource "azurerm_key_vault" "Key_vault" {
  name                        = var.keyvault_name
  resource_group_name = var.resource_name
  location = var.location
  sku_name                    = var.sku_name
  tenant_id                   = var.tenant_id
  purge_protection_enabled    = var.purge_protection_enabled
  soft_delete_retention_days = var.soft_delete_retention_days
  access_policy {
    tenant_id = var.access_policy_tenant_id
    object_id = var.access_policy_object_id
    
    secret_permissions = var.access_policy_secret_permissions
    certificate_permissions = var.certificate_permissions
    key_permissions = var.access_policy_key_permissions
  }
}