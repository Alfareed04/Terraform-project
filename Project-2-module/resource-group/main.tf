//Resource Group

resource "azurerm_resource_group" "rg" {
  name = var.resource_name
  location = var.location
}