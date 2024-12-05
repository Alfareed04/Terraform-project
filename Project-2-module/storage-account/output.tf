output "storage_account" {
  value = azurerm_storage_account.storage_account
}

output "storage_account_name" {
  value = azurerm_storage_account.storage_account.name
}

output "id" {
  value = azurerm_storage_account.storage_account.id
}