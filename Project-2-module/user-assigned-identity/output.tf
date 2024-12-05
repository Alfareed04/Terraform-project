output "user_assigned_identity" {
  value = azurerm_user_assigned_identity.user_assigned_identity
}

output "id" {
  value = azurerm_user_assigned_identity.user_assigned_identity.principal_id
}