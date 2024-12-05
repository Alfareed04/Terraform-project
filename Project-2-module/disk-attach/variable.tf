variable "managed_disk_id" {
  type = string
}
variable "virtual_machine_id" {
  type = string
}

variable "lun" {
  type = number
}

variable "caching" {
  type = string
}