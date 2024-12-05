resource "azurerm_private_dns_zone_virtual_network_link" "dns_link" {
  name                  = var.dns_link_name
  resource_group_name   = var.resource_name
  private_dns_zone_name = var.private_dns_zone_name
  virtual_network_id    = var.virtual_network_id
}