variable "key_name" {
  type = string
}

variable "key_vault_id" {
  type = string
}

variable "key_type" {
  type = string
}

variable "key_size" {
  type = number
}

variable "key_opts" {
  type = list(string)
}