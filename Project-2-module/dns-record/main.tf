resource "azurerm_private_dns_a_record" "dns_record" {
  name                = var.dns_record_name
  zone_name           = var.zone_name
  resource_group_name = var.resource_name
  ttl                 = var.ttl
  records             = var.records
}