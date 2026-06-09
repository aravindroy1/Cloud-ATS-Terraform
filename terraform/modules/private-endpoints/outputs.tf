output "app_service_private_endpoint_id" {
  value = azurerm_private_endpoint.app_service.id
}

output "app_service_private_ip" {
  value = azurerm_private_endpoint.app_service.private_service_connection[0].private_ip_address
}

output "key_vault_private_endpoint_id" {
  value = azurerm_private_endpoint.key_vault.id
}

output "cosmosdb_private_endpoint_id" {
  value = azurerm_private_endpoint.cosmosdb.id
}

output "storage_blob_private_endpoint_id" {
  value = azurerm_private_endpoint.storage_blob.id
}

output "storage_queue_private_endpoint_id" {
  value = azurerm_private_endpoint.storage_queue.id
}

output "storage_table_private_endpoint_id" {
  value = azurerm_private_endpoint.storage_table.id
}

output "storage_file_private_endpoint_id" {
  value = azurerm_private_endpoint.storage_file.id
}

output "document_intelligence_private_endpoint_id" {
  value = azurerm_private_endpoint.document_intelligence.id
}
