resource "azurerm_firewall" "firewall" {
  name                = var.firewall_name
  location            = var.location
  resource_group_name = var.resource_name
   sku_name = var.sku_name
   sku_tier = var.sku_tier

  ip_configuration {
    name                 = var.ip_configuration_name
    subnet_id            = var.subnet_id
    public_ip_address_id = var.public_ip_address_id
  }
  firewall_policy_id = var.firewall_policy_id
}