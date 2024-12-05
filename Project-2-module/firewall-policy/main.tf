resource "azurerm_firewall_policy" "firewall_policy" {
  name                = var.firewall_policy_name
  location            = var.location
  resource_group_name = var.resource_name
  sku = var.sku
}