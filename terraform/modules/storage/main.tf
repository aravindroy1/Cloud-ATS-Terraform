resource "azurerm_storage_account" "main" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
  allow_blob_public_access = false
  public_network_access_enabled = false

  network_rules {
    default_action             = "Deny"
    virtual_network_subnet_ids = [var.data_subnet_id]
  }

  tags = var.tags
}

resource "azurerm_storage_container" "resumes" {
  name                  = "resumes"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"
}
