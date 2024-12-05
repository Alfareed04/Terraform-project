output "vm_disk" {
  value = azurerm_managed_disk.vm_disk
}

output "disk_name" {
  value = azurerm_managed_disk.vm_disk.name
}

output "id" {
  value = azurerm_managed_disk.vm_disk.id
}