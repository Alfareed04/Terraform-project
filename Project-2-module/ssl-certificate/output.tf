output "ssl_certificate" {
  value = azurerm_key_vault_certificate.ssl_certificate
}

output "secret_id" {
  value = azurerm_key_vault_certificate.ssl_certificate.secret_id
}