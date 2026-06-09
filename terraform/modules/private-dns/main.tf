resource "azurerm_private_dns_zone" "app_service" {
  name                = "privatelink.azurewebsites.net"
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_private_dns_zone" "key_vault" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_private_dns_zone" "document_intelligence" {
  name                = "privatelink.documents.azure.com"
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_private_dns_zone" "storage_blob" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "app_service" {
  name                  = "app-service-link-${var.environment}"
  resource_group_name   = var.resource_group_name
  private_dns_zone_id   = azurerm_private_dns_zone.app_service.id
  virtual_network_id    = var.vnet_id
  registration_enabled  = false
}

resource "azurerm_private_dns_zone_virtual_network_link" "key_vault" {
  name                  = "key-vault-link-${var.environment}"
  resource_group_name   = var.resource_group_name
  private_dns_zone_id   = azurerm_private_dns_zone.key_vault.id
  virtual_network_id    = var.vnet_id
  registration_enabled  = false
}

resource "azurerm_private_dns_zone_virtual_network_link" "document_intelligence" {
  name                  = "document-intelligence-link-${var.environment}"
  resource_group_name   = var.resource_group_name
  private_dns_zone_id   = azurerm_private_dns_zone.document_intelligence.id
  virtual_network_id    = var.vnet_id
  registration_enabled  = false
}

resource "azurerm_private_dns_zone_virtual_network_link" "storage_blob" {
  name                  = "storage-blob-link-${var.environment}"
  resource_group_name   = var.resource_group_name
  private_dns_zone_id   = azurerm_private_dns_zone.storage_blob.id
  virtual_network_id    = var.vnet_id
  registration_enabled  = false
}
