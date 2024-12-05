# Creates the Key vault certificate 
resource "azurerm_key_vault_certificate" "ssl_certificate" {
  name         = var.ssl_name
  key_vault_id = var.key_vault_id

  certificate_policy {
    issuer_parameters {
      name = var.issuer_parameters_name
    }

    key_properties {
      exportable = var.exportable
      key_size   = var.key_size
      key_type   = var.key_type
      reuse_key  = var.reuse_key
    }

    lifetime_action {
      action {
        action_type = var.action_type
      }

      trigger {
        days_before_expiry = var.days_before_expiry
      }
    }

    secret_properties {
      content_type = var.content_type
    }

    x509_certificate_properties {
      extended_key_usage = var.extended_key_usage

      key_usage = var.key_usage

      subject_alternative_names {
        dns_names = var.dns_names
      }

      subject            = var.subject
      validity_in_months = var.validity_in_months
    }
  }

}