
resource "azurerm_subnet" "subnet" {
  name = var.subnet_name
  address_prefixes = [var.address_prefix]
  virtual_network_name = var.virtual_name
  resource_group_name = var.resource_name
}