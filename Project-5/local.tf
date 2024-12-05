locals {
  application_gateway_backend_address_pool_ids = [for pool in module.appGW.backend_address_pool : pool.id]
}