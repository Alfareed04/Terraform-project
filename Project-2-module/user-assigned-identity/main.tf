resource "azurerm_user_assigned_identity" "user_assigned_identity" {
  name                =var.user_assigned_identity_name             
  resource_group_name = var.resource_name
  location            = var.location
 
}