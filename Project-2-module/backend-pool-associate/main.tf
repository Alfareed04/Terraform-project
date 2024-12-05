
resource "azurerm_network_interface_backend_address_pool_association" "backend-nic-associate" {
  network_interface_id = var.network_interface_id
  backend_address_pool_id = var.backend_address_pool_id
  ip_configuration_name = var.ip_configuration_name
}