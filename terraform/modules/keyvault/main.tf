resource "azurerm_key_vault" "main" {
  name                        = var.key_vault_name
  resource_group_name         = var.resource_group_name
  location                    = var.location
  tenant_id                   = var.tenant_id
  sku_name                    = "standard"
  soft_delete_enabled         = true
  purge_protection_enabled    = false
  public_network_access_enabled = false
  enabled_for_disk_encryption = true
  enabled_for_template_deployment = true
  enable_rbac_authorization   = true

  network_acls {
    default_action = "Deny"
  }

  tags = var.tags
}

resource "azurerm_key_vault_certificate" "app_gateway" {
  name         = var.certificate_name
  key_vault_id = azurerm_key_vault.main.id

  certificate_policy {
    issuer_parameters {
      name = "Self"
    }

    key_properties {
      exportable = true
      key_type   = "RSA"
      key_size   = 2048
      reuse_key  = true
    }

    secret_properties {
      content_type = "application/x-pkcs12"
    }

    x509_certificate_properties {
      subject            = var.certificate_subject
      validity_in_months = 12
      key_usage = [
        "digitalSignature",
        "keyEncipherment",
      ]
      extended_key_usage = [
        "serverAuth",
      ]
    }
  }
}

resource "azurerm_key_vault_secret" "main" {
  for_each          = var.secrets
  name              = each.key
  value             = each.value
  key_vault_id      = azurerm_key_vault.main.id
  content_type      = "text/plain"
}

resource "azurerm_role_assignment" "key_vault_admin" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = var.current_principal_id
}
