output "application_gateway_id" {
  value = azurerm_application_gateway.main.id
}

output "application_gateway_name" {
  value = azurerm_application_gateway.main.name
}

output "public_ip_address" {
  value = azurerm_public_ip.main.ip_address
}

output "public_ip_fqdn" {
  value = azurerm_public_ip.main.fqdn
}

