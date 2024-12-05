variable "ssl_name" {
  type = string
}

variable "key_vault_id" {
  type = string
}

variable "issuer_parameters_name" {
  type = string
}

variable "exportable" {
  type = bool
}

variable "key_size" {
  type = number
}

variable "key_type" {
  type = string
}

variable "reuse_key" {
  type = bool
}

variable "action_type" {
  type = string
}

variable "days_before_expiry" {
  type = number
}

variable "content_type" {
  type = string
}

variable "extended_key_usage" {
  type = list(string)
}

variable "key_usage" {
  type = list(string)
}

variable "dns_names" {
  type = list(string)
}

variable "subject" {
  type = string
}

variable "validity_in_months" {
  type = number
}