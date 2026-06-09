resource "azurerm_private_endpoint" "app_service" {
  name                = "pe-appservice-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.data_subnet_id

  private_service_connection {
    name                           = "app-service-connection"
    private_connection_resource_id = var.app_service_id
    is_manual_connection           = false
    subresource_names              = ["sites"]
  }
}

resource "azurerm_private_endpoint" "key_vault" {
  name                = "pe-keyvault-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.data_subnet_id

  private_service_connection {
    name                           = "key-vault-connection"
    private_connection_resource_id = var.key_vault_id
    is_manual_connection           = false
    subresource_names              = ["vault"]
  }
}

resource "azurerm_private_endpoint" "cosmosdb" {
  name                = "pe-cosmosdb-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.data_subnet_id

  private_service_connection {
    name                           = "cosmosdb-connection"
    private_connection_resource_id = var.cosmosdb_id
    is_manual_connection           = false
    subresource_names              = ["mongo"]
  }
}

resource "azurerm_private_endpoint" "storage_blob" {
  name                = "pe-storage-blob-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.data_subnet_id

  private_service_connection {
    name                           = "storage-blob-connection"
    private_connection_resource_id = var.storage_account_id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }
}

resource "azurerm_private_endpoint" "document_intelligence" {
  name                = "pe-documentintelligence-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.data_subnet_id

  private_service_connection {
    name                           = "document-intelligence-connection"
    private_connection_resource_id = var.document_intelligence_id
    is_manual_connection           = false
    subresource_names              = ["formrecognizer"]
  }
}

resource "azurerm_private_endpoint_dns_zone_group" "app_service" {
  name                = "app-service-zone-group-${var.environment}"
  private_endpoint_id = azurerm_private_endpoint.app_service.id
  private_dns_zone_id = var.app_service_dns_zone_id
  record_sets         = [var.app_service_name]
}

resource "azurerm_private_endpoint_dns_zone_group" "key_vault" {
  name                = "key-vault-zone-group-${var.environment}"
  private_endpoint_id = azurerm_private_endpoint.key_vault.id
  private_dns_zone_id = var.key_vault_dns_zone_id
  record_sets         = [var.key_vault_name]
}

resource "azurerm_private_endpoint_dns_zone_group" "cosmosdb" {
  name                = "cosmosdb-zone-group-${var.environment}"
  private_endpoint_id = azurerm_private_endpoint.cosmosdb.id
  private_dns_zone_id = var.cosmosdb_dns_zone_id
  record_sets         = [var.cosmosdb_name]
}

resource "azurerm_private_endpoint_dns_zone_group" "storage_blob" {
  name                = "storage-blob-zone-group-${var.environment}"
  private_endpoint_id = azurerm_private_endpoint.storage_blob.id
  private_dns_zone_id = var.storage_blob_dns_zone_id
  record_sets         = [var.storage_account_name]
}

resource "azurerm_private_endpoint_dns_zone_group" "document_intelligence" {
  name                = "document-intelligence-zone-group-${var.environment}"
  private_endpoint_id = azurerm_private_endpoint.document_intelligence.id
  private_dns_zone_id = var.document_intelligence_dns_zone_id
  record_sets         = [var.document_intelligence_name]
}

output "app_service_private_ip" {
  value = azurerm_private_endpoint.app_service.private_service_connection[0].private_ip_address
}

output "key_vault_private_ip" {
  value = azurerm_private_endpoint.key_vault.private_service_connection[0].private_ip_address
}

output "cosmosdb_private_ip" {
  value = azurerm_private_endpoint.cosmosdb.private_service_connection[0].private_ip_address
}

output "storage_private_ip" {
  value = azurerm_private_endpoint.storage_blob.private_service_connection[0].private_ip_address
}

output "document_intelligence_private_ip" {
  value = azurerm_private_endpoint.document_intelligence.private_service_connection[0].private_ip_address
}
