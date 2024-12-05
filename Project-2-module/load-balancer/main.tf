resource "azurerm_lb" "load_balancer" {
  name                = var.load_balancer_name
  location            = var.location
  resource_group_name = var.resource_name
  sku                 = var.sku

  frontend_ip_configuration {
    name                 = var.frontend_ip_name
    subnet_id            = var.subnet_id
    private_ip_address_allocation = var.forntend_private_ip_address_allocation
  }
  
}



