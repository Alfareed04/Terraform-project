output "disk_encryption" {
  value = azurerm_disk_encryption_set.disk_encryption
}

output "disk_encryption_name" {
  value = azurerm_disk_encryption_set.disk_encryption.name
}

output "id" {
  value = azurerm_disk_encryption_set.disk_encryption.id
}