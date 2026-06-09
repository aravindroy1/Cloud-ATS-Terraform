resource "azurerm_cosmosdb_account" "main" {
  name                = var.account_name
  location            = var.location
  resource_group_name = var.resource_group_name
  offer_type          = "Standard"
  kind                = "MongoDB"
  consistency_policy {
    consistency_level = "Session"
  }
  capabilities {
    name = "EnableMongo"
  }
  capabilities {
    name = "EnableServerless"
  }
  public_network_access_enabled = false
  is_virtual_network_filter_enabled = true
  geo_location {
    location          = var.location
    failover_priority = 0
  }
  tags = var.tags
}
