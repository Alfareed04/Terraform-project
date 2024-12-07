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

  dynamic "key" {
    for_each = var.keys
    content {
      name     = key.value.name
      key_type = key.value.key_type
      key_size = key.value.key_size
      key_opts = key.value.key_opts
    }
  }

  dynamic "secrets" {
    for_each = var.secrets
    content {
      name  = secrets.value.name
      value = secrets.value.value
    }
  }

}

# access_policy {
#   tenant_id = var.access_policy_tenant_id
#   object_id = var.access_policy_object_id

#   secret_permissions = var.access_policy_secret_permissions
#   certificate_permissions = var.certificate_permissions
#   key_permissions = var.access_policy_key_permissions
# }
