terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }
  required_version = ">= 1.1.0" 


    backend "azurerm" {
    resource_group_name  = "backend_rg"
    storage_account_name = "backendstgconfig"
    container_name       = "container-config"
    key                  = "Terraform-project.tfstate"
  }
}

provider "azurerm" {
  features {}
}

// data block resources

data "azurerm_resource_group" "rg" {
  name = "Project3-rg"
}

// data block vnet

data "azurerm_virtual_network" "vnet" {
  name                = "project3_vnet"
  resource_group_name = "Project3-rg"

  depends_on = [data.azurerm_resource_group.rg]
}

// data block subnet

data "azurerm_subnet" "subnet" {
  for_each             = var.subnets
  name                 = each.key
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_virtual_network.vnet.resource_group_name

  depends_on = [data.azurerm_resource_group.rg, data.azurerm_virtual_network.vnet]
}

# Add a resource block to create a new subnet if required
module "appgw_subnet" {
  source         = "../Project-2-module/subnet"
  for_each       = var.appgw-subnet
  subnet_name    = each.key
  address_prefix = each.value.address_prefix
  virtual_name   = data.azurerm_virtual_network.vnet.name
  resource_name  = data.azurerm_virtual_network.vnet.resource_group_name

  depends_on = [data.azurerm_resource_group.rg, data.azurerm_virtual_network.vnet, data.azurerm_subnet.subnet]
}

// data block keyvault

data "azurerm_key_vault" "Key_vault" {
  name                = "vault-project04"
  resource_group_name = data.azurerm_resource_group.rg.name
}

//data block admin_username

data "azurerm_key_vault_secret" "admin_username" {
  name         = "keyvault-username"
  key_vault_id = data.azurerm_key_vault.Key_vault.id

  depends_on = [data.azurerm_key_vault.Key_vault]
}

//data block admin_password

data "azurerm_key_vault_secret" "admin_password" {
  name         = "keyvault-password"
  key_vault_id = data.azurerm_key_vault.Key_vault.id

  depends_on = [data.azurerm_key_vault.Key_vault]
}

// ssl certificate

module "ssl_certificate" {
  source                 = "../Project-2-module/ssl-certificate"
  ssl_name               = "ssl-certificate"
  key_vault_id           = data.azurerm_key_vault.Key_vault.id
  issuer_parameters_name = "self"
  exportable             = true
  key_size               = 2048
  key_type               = "RSA"
  reuse_key              = true
  action_type            = "AutoRenew"
  days_before_expiry     = 30
  content_type           = "application/x-pkcs12"
  extended_key_usage     = ["1.3.6.1.5.5.7.3.1"]
  key_usage = [
    "cRLSign",
    "dataEncipherment",
    "digitalSignature",
    "keyAgreement",
    "keyCertSign",
    "keyEncipherment",
  ]
  dns_names          = ["internal.contoso.com", "domain.hello.world"]
  subject            = "CN=hello.world"
  validity_in_months = 12

  depends_on = [data.azurerm_key_vault.Key_vault]
}

// keyvault private endpoint

module "private_endpoint" {
  source                          = "../Project-2-module/privateend-point"
  private_endpoint_name           = "private-endpoint"
  resource_name                   = data.azurerm_resource_group.rg.name
  location                        = data.azurerm_resource_group.rg.location
  subnet_id                       = data.azurerm_subnet.subnet["subnet02"].id
  private_service_connection_name = "keyvault-private-connection"
  private_connection_resource_id  = data.azurerm_key_vault.Key_vault.id
  is_manual_connection            = false
  subresource_names               = ["vault"]

  depends_on = [data.azurerm_resource_group.rg, data.azurerm_subnet.subnet, data.azurerm_key_vault.Key_vault]
}

// DNS Zone

module "dns_zone" {
  source        = "../Project-2-module/dns-zone"
  dns_name      = var.dns_name
  resource_name = module.private_endpoint.resource_name

  depends_on = [module.private_endpoint]
}

// DNS Zone to Virtual Network Link

module "dns_link" {
  source                = "../Project-2-module/dnszone-link-vnet"
  dns_link_name         = var.dns_link_name
  resource_name         = module.private_endpoint.resource_name
  private_dns_zone_name = module.dns_zone.name
  virtual_network_id    = data.azurerm_virtual_network.vnet.id

  depends_on = [module.private_endpoint, module.dns_zone, data.azurerm_virtual_network.vnet]
}

// DNS Record

module "dns_record" {
  source          = "../Project-2-module/dns-record"
  dns_record_name = var.dns_record_name
  zone_name       = module.dns_zone.name
  resource_name   = module.private_endpoint.resource_name
  ttl             = 300
  records         = [module.private_endpoint.private_service_connection_id]

  depends_on = [module.private_endpoint, module.dns_zone]
}

// data block user identity

# module "keyvault_user_assigned_identity" {
#   source = "../Project-2-module/user-assigned-identity"
#   user_assigned_identity_name = var.user_assigned_identity_name
#   resource_name = data.azurerm_resource_group.rg.name
#   location = data.azurerm_resource_group.rg.location

#   depends_on = [ data.azurerm_resource_group.rg, data.azurerm_key_vault.Key_vault ]
# }

data "azurerm_user_assigned_identity" "user_assigned_identity" {
  name                = var.user_assigned_identity_name
  resource_group_name = data.azurerm_resource_group.rg.name
}

# data "azurerm_client_config" "current" {}
# data "azuread_client_config" "current" {}

# module "keyvault_access_policy" {
#   source                  = "../Project-2-module/keyvault-policy"
#   keyvault_id             = data.azurerm_key_vault.Key_vault.id
#   tenant_id               = data.azurerm_client_config.current.tenant_id
#   object_id               = data.azurerm_user_assigned_identity.user_assigned_identity.principal_id
#   key_permissions         = ["Get", "List"]
#   certificate_permissions = ["Get", "List"]
#   secret_permissions      = ["Get", "List"]
#   depends_on              = [data.azurerm_key_vault.Key_vault, data.azurerm_user_assigned_identity.user_assigned_identity]

# }

// Public ip

module "Public_ip" {
  source            = "../Project-2-module/public-ip"
  public_ip_name    = "Appgw-pub-IP"
  resource_name     = data.azurerm_resource_group.rg.name
  location          = data.azurerm_resource_group.rg.location
  allocation_method = "Static"
  sku               = "Standard"
}

// Application Gateway

module "appGW" {
  source        = "../Project-2-module/app-gateway"
  appgw_name    = "App-GW"
  resource_name = data.azurerm_resource_group.rg.name
  location      = data.azurerm_resource_group.rg.location

  name     = "Standard_v2"
  tier     = "Standard_v2"
  capacity = 2

  type         = "UserAssigned"
  identity_ids = [data.azurerm_user_assigned_identity.user_assigned_identity.id]

  gateway_ip_configuration_name = "appgw-ip-config"
  subnet_id                     = module.appgw_subnet["AppGw"].id

  frontend_ip_configuration_name = "appgw-frontend-ip"
  public_ip_address_id           = module.Public_ip.id

  frontend_port_name = "frontend-port"
  port               = 443

  backend_address_pool_name = "appgw-backend-pool"

  backend_http_settings_name = "appgw-backend-http-settings"
  cookie_based_affinity      = "Disabled"
  backend_http_settings_port = 80
  protocol                   = "Http"
  request_timeout            = 20

  http_listener_name                  = "appgw-http-listener"
  http_frontend_ip_configuration_name = "appgw-frontend-ip"
  http_listener_frontend_port_name    = "frontend-port"
  http_listener_protocol              = "Https"
  ssl_certificate_name                = "ssl-certificate"
  key_vault_secret_id                 = module.ssl_certificate.secret_id

  request_routing_rule_name          = "appgw-routing-rule"
  rule_type                          = "Basic"
  routing_http_listener_name         = "appgw-http-listener"
  routing_backend_address_pool_name  = "appgw-backend-pool"
  routing_backend_http_settings_name = "appgw-backend-http-settings"

  depends_on = [data.azurerm_user_assigned_identity.user_assigned_identity, module.Public_ip,
  module.ssl_certificate, data.azurerm_subnet.subnet]

}

// VMSS

module "vmss" {
  source                                       = "../Project-2-module/vmss"
  vmss_name                                    = "myvmss"
  resource_name                                = data.azurerm_resource_group.rg.name
  location                                     = data.azurerm_resource_group.rg.location
  sku                                          = "Standard_DS1_v2"
  instances                                    = 2
  admin_username                               = data.azurerm_key_vault_secret.admin_username.value
  admin_password                               = data.azurerm_key_vault_secret.admin_password.value
  nic_name                                     = "myvmss"
  nic_primary                                  = true
  ip_configuration_name                        = "internal"
  subnet_id                                    = data.azurerm_subnet.subnet["subnet02"].id
  application_gateway_backend_address_pool_ids = [local.application_gateway_backend_address_pool_ids[0]]
  type                                         = "UserAssigned"
  identity_ids                                 = [data.azurerm_user_assigned_identity.user_assigned_identity.id]
  os_caching                                   = "ReadWrite"
  storage_account_type                         = "Standard_LRS"
  image_publisher                              = "MicrosoftWindowsServer"
  image_offer                                  = "WindowsServer"
  image_sku                                    = "2019-Datacenter"
  image_version                                = "latest"

  depends_on = [data.azurerm_resource_group.rg, data.azurerm_subnet.subnet, data.azurerm_key_vault_secret.admin_username,
  data.azurerm_key_vault_secret.admin_password, data.azurerm_user_assigned_identity.user_assigned_identity, module.appGW]
}
