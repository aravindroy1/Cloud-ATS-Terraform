output "appgw_nsg_id" {
  value = azurerm_network_security_group.appgw.id
}

output "app_nsg_id" {
  value = azurerm_network_security_group.app.id
}

output "data_nsg_id" {
  value = azurerm_network_security_group.data.id
}

