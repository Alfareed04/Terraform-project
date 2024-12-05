variable "dns_record_name" {
  type = string
}

variable "zone_name" {
  type = string
}

variable "resource_name" {
  type = string
}

variable "ttl" {
  type = number
}

variable "records" {
  type = list(string)
}