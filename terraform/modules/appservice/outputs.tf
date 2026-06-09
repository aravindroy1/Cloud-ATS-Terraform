output "app_service_id" {
  value = azurerm_linux_web_app.main.id
}

output "app_service_name" {
  value = azurerm_linux_web_app.main.name
}

output "default_hostname" {
  value = azurerm_linux_web_app.main.default_hostname
}

output "principal_id" {
  value = azurerm_linux_web_app.main.identity[0].principal_id
}

