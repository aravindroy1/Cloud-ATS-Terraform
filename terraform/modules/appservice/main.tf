resource "azurerm_app_service_plan" "main" {
  name                = "asp-${var.application_name}-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "PremiumV3"
    size = var.app_service_plan_sku
  }

  tags = var.tags
}

resource "azurerm_linux_web_app" "main" {
  name                = var.app_service_name
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = azurerm_app_service_plan.main.id
  https_only          = true
  public_network_access_enabled = false
  client_affinity_enabled = false

  identity {
    type = "SystemAssigned"
  }

  site_config {
    linux_fx_version                   = var.app_service_linux_fx_version
    always_on                          = true
    ftps_state                         = "Disabled"
    minimum_tls_version                = "1.2"
    vnet_route_all_enabled             = true
  }

  app_settings = {
    WEBSITE_RUN_FROM_PACKAGE                = "1"
    AZURE_STORAGE_ACCOUNT_NAME              = var.storage_account_name
    AZURE_STORAGE_CONNECTION_STRING         = var.storage_account_connection_string
    KEY_VAULT_NAME                          = var.key_vault_name
    JWT_SECRET                              = var.jwt_secret
    AZURE_CLIENT_ID                         = var.entra_client_id
    AZURE_CLIENT_SECRET                     = var.entra_client_secret
    AZURE_TENANT_ID                         = var.entra_tenant_id
    AZURE_REDIRECT_URI                      = var.entra_redirect_uri
    APPLICATIONINSIGHTS_CONNECTION_STRING   = var.app_insights_connection_string
  }

  virtual_network_subnet_id = var.app_integration_subnet_id

  tags = var.tags
}
