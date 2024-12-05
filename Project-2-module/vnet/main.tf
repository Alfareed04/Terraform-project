
resource "azurerm_virtual_network" "vnet" {  
name                = var.vnet_name 
location            = var.location
resource_group_name = var.resource_name 
address_space = var.address_space

# dynamic "subnets" {
#   for_each = var.subnets
#   content {
#     name = subnets.value.name
#     address_prefix = subnets.value.address_prefix
#   }
# }
}

