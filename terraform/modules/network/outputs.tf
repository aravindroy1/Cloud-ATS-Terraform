output "vnet_id" {
  value = azurerm_virtual_network.main.id
}

output "app_gateway_subnet_id" {
  value = azurerm_subnet.app_gateway.id
}

output "app_integration_subnet_id" {
  value = azurerm_subnet.app_integration.id
}

output "data_subnet_id" {
  value = azurerm_subnet.data.id
}
