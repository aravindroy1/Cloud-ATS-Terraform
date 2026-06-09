output "key_vault_id" {
  value = azurerm_key_vault.main.id
}

output "key_vault_name" {
  value = azurerm_key_vault.main.name
}

output "key_vault_uri" {
  value = azurerm_key_vault.main.vault_uri
}

output "certificate_secret_id" {
  value = azurerm_key_vault_certificate.app_gateway.secret_id
}

output "secret_ids" {
  value = {
    for name, secret in azurerm_key_vault_secret.main : name => secret.id
  }
  sensitive = true
}
