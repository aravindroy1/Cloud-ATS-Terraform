resource "azurerm_service_plan" "main" {
  name                = "asp-func-${var.application_name}-${var.environment}"
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = var.function_app_plan_sku
  tags                = var.tags
}

resource "azurerm_linux_function_app" "main" {
  name                          = "func-${var.application_name}-${var.environment}"
  resource_group_name           = var.resource_group_name
  location                      = var.location
  service_plan_id               = azurerm_service_plan.main.id
  storage_account_name          = var.storage_account_name
  storage_account_access_key    = var.storage_account_access_key
  public_network_access_enabled = false
  https_only                    = true
  virtual_network_subnet_id     = var.app_integration_subnet_id
  tags                          = var.tags

  identity {
    type = "SystemAssigned"
  }

  site_config {
    always_on                              = true
    ftps_state                             = "Disabled"
    minimum_tls_version                    = "1.2"
    scm_minimum_tls_version                = "1.2"
    vnet_route_all_enabled                 = true
    application_insights_connection_string = var.application_insights_connection_string

    application_stack {
      node_version = var.function_app_runtime_version
    }
  }

  app_settings = {
    FUNCTIONS_EXTENSION_VERSION              = "~4"
    FUNCTIONS_WORKER_RUNTIME                 = "node"
    WEBSITE_RUN_FROM_PACKAGE                 = "1"
    WEBSITE_VNET_ROUTE_ALL                   = "1"
    AzureWebJobsStorage                      = var.storage_account_connection_string
    AZURE_STORAGE_CONNECTION_STRING          = var.storage_account_connection_string
    AZURE_STORAGE_ACCOUNT_NAME               = var.storage_account_name
    AZURE_STORAGE_CONTAINER_NAME             = var.storage_container_name
    KEY_VAULT_NAME                           = var.key_vault_name
    MONGO_URI                                = var.cosmosdb_mongo_connection_string
    AZURE_DOCUMENT_INTELLIGENCE_ENDPOINT     = var.document_intelligence_endpoint
    AZURE_DOCUMENT_INTELLIGENCE_KEY          = var.document_intelligence_key
    APP_DASHBOARD_URL                        = var.app_dashboard_url
    SMTP_HOST                                = coalesce(var.smtp_host, "")
    SMTP_PORT                                = tostring(var.smtp_port)
    SMTP_USER                                = coalesce(var.smtp_user, "")
    SMTP_PASS                                = coalesce(var.smtp_pass, "")
    SMTP_FROM                                = var.smtp_from
  }
}

resource "azurerm_role_assignment" "key_vault_secrets_user" {
  scope                = var.key_vault_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_linux_function_app.main.identity[0].principal_id
}

resource "azurerm_role_assignment" "storage_blob_data_contributor" {
  scope                = var.storage_account_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_linux_function_app.main.identity[0].principal_id
}

