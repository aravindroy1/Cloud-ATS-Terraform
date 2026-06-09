output "account_id" {
  value = azurerm_cosmosdb_account.main.id
}

output "account_name" {
  value = azurerm_cosmosdb_account.main.name
}

output "endpoint" {
  value = azurerm_cosmosdb_account.main.endpoint
}

output "primary_mongodb_connection_string" {
  value     = azurerm_cosmosdb_account.main.connection_strings[0]
  sensitive = true
}
