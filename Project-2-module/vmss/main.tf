resource "azurerm_windows_virtual_machine_scale_set" "vmss" {
  name                = var.vmss_name
  resource_group_name = var.resource_name
  location            = var.location
  sku                 = var.sku
  instances           = var.instances
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  
 network_interface {
    name    = var.nic_name
    primary = var.nic_primary

    ip_configuration {
      name      = var.ip_configuration_name
      subnet_id = var.subnet_id
      application_gateway_backend_address_pool_ids = var.application_gateway_backend_address_pool_ids
    }
  }

  identity {
    type = var.type
    identity_ids = var.identity_ids
  }

  os_disk {
    caching              = var.os_caching
    storage_account_type = var.storage_account_type
  }

  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }
}
