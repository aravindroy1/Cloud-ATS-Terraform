locals {
  environment                  = lower(var.environment)
  rg_name                      = "cloudats-rg-${local.environment}"
  vnet_name                    = "cloudats-vnet-${local.environment}"
  app_gateway_name             = "cloudats-agw-${local.environment}"
  app_gateway_dns_label        = "cloudats-${local.environment}-agw"
  app_gateway_public_fqdn      = "${local.app_gateway_dns_label}.${var.location}.cloudapp.azure.com"
  app_service_name             = "${var.application_name}-${local.environment}"
  storage_account_name         = substr(lower("cloudats${local.environment}sa"), 0, 24)
  key_vault_name               = "cloudats-kv-${local.environment}"
  cosmosdb_account_name        = lower("cloudatscosmos${local.environment}")
  log_analytics_workspace_name = "cloudats-law-${local.environment}"
  app_insights_name            = "cloudats-ai-${local.environment}"
  document_intelligence_name   = "di-${var.application_name}-${local.environment}"
  function_app_name            = "func-${var.application_name}-${local.environment}"
  certificate_name             = "appgw-cert-${local.environment}"
}

resource "azurerm_resource_group" "main" {
  name     = local.rg_name
  location = var.location
  tags     = var.tags
}

data "azurerm_client_config" "current" {}

module "network" {
  source              = "./modules/network"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  environment         = local.environment
  vnet_name           = local.vnet_name
  tags                = var.tags
}

module "nsg" {
  source                    = "./modules/nsg"
  resource_group_name       = azurerm_resource_group.main.name
  location                  = azurerm_resource_group.main.location
  app_gateway_subnet_id     = module.network.app_gateway_subnet_id
  app_integration_subnet_id = module.network.app_integration_subnet_id
  data_subnet_id            = module.network.data_subnet_id
  tags                      = var.tags
}

module "keyvault" {
  source                     = "./modules/keyvault"
  resource_group_name        = azurerm_resource_group.main.name
  location                   = azurerm_resource_group.main.location
  key_vault_name             = local.key_vault_name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  current_principal_id       = data.azurerm_client_config.current.object_id
  app_gateway_identity_principal_id = ""
  certificate_name           = local.certificate_name
  certificate_subject        = "CN=${local.app_gateway_dns_label}.cloudapp.azure.com"
  secrets = {
    jwt_secret = var.jwt_secret
  }
  tags = var.tags
}

module "storage" {
  source              = "./modules/storage"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  storage_account_name = local.storage_account_name
  data_subnet_id       = module.network.data_subnet_id
  tags                 = var.tags
}

module "cosmosdb" {
  source              = "./modules/cosmosdb"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  account_name        = local.cosmosdb_account_name
  tags                = var.tags
}

module "monitoring" {
  source                        = "./modules/monitoring"
  resource_group_name           = azurerm_resource_group.main.name
  location                      = azurerm_resource_group.main.location
  environment                   = local.environment
  application_name              = var.application_name
  log_analytics_retention_days  = var.log_analytics_retention_days
  tags                          = var.tags
}

module "private_dns" {
  source              = "./modules/private-dns"
  resource_group_name = azurerm_resource_group.main.name
  vnet_id             = module.network.vnet_id
  environment         = local.environment
  tags                = var.tags
}

module "appservice" {
  source                          = "./modules/appservice"
  resource_group_name             = azurerm_resource_group.main.name
  location                        = azurerm_resource_group.main.location
  environment                     = local.environment
  application_name                = var.application_name
  app_service_name                = local.app_service_name
  app_service_plan_sku            = var.app_service_sku
  app_service_linux_fx_version    = var.app_service_linux_fx_version
  app_integration_subnet_id       = module.network.app_integration_subnet_id
  storage_account_name            = module.storage.storage_account_name
  storage_account_connection_string = module.storage.primary_connection_string
  key_vault_name                  = module.keyvault.key_vault_name
  jwt_secret                      = var.jwt_secret
  entra_client_id                 = module.entra_id.client_id
  entra_client_secret             = module.entra_id.client_secret
  entra_tenant_id                 = var.tenant_id
  entra_redirect_uri              = "https://${local.app_gateway_public_fqdn}/api/auth/redirect"
  app_insights_connection_string = module.monitoring.application_insights_connection_string
  tags                            = var.tags
}

module "document_intelligence" {
  source              = "./modules/document-intelligence"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  environment         = local.environment
  application_name    = var.application_name
  tags                = var.tags
}

module "functionapp" {
  source                         = "./modules/functionapp"
  resource_group_name            = azurerm_resource_group.main.name
  location                       = azurerm_resource_group.main.location
  environment                    = local.environment
  application_name               = var.application_name
  function_app_plan_sku          = var.function_app_plan_sku
  function_app_runtime_version   = var.function_app_runtime_version
  app_integration_subnet_id      = module.network.app_integration_subnet_id
  storage_account_id             = module.storage.storage_account_id
  storage_account_name           = module.storage.storage_account_name
  storage_account_access_key     = module.storage.primary_access_key
  storage_account_connection_string = module.storage.primary_connection_string
  storage_container_name         = module.storage.resume_container_name
  key_vault_id                   = module.keyvault.key_vault_id
  key_vault_name                 = module.keyvault.key_vault_name
  cosmosdb_mongo_connection_string = module.cosmosdb.primary_mongodb_connection_string
  document_intelligence_endpoint = module.document_intelligence.endpoint
  document_intelligence_key     = module.document_intelligence.primary_access_key
  app_dashboard_url              = "https://${local.app_gateway_public_fqdn}"
  application_insights_connection_string = module.monitoring.application_insights_connection_string
  smtp_host                      = var.smtp_host
  smtp_port                      = var.smtp_port
  smtp_user                      = var.smtp_user
  smtp_pass                      = var.smtp_pass
  smtp_from                      = var.smtp_from
  tags                           = var.tags
}

module "private_endpoints" {
  source                       = "./modules/private-endpoints"
  resource_group_name          = azurerm_resource_group.main.name
  location                     = azurerm_resource_group.main.location
  environment                  = local.environment
  data_subnet_id               = module.network.data_subnet_id
  app_service_id               = module.appservice.app_service_id
  app_service_name             = module.appservice.app_service_name
  key_vault_id                 = module.keyvault.key_vault_id
  key_vault_name               = module.keyvault.key_vault_name
  cosmosdb_id                  = module.cosmosdb.account_id
  cosmosdb_name                = module.cosmosdb.account_name
  storage_account_id           = module.storage.storage_account_id
  storage_account_name         = module.storage.storage_account_name
  app_service_dns_zone_id      = module.private_dns.zone_ids["privatelink.azurewebsites.net"]
  key_vault_dns_zone_id        = module.private_dns.zone_ids["privatelink.vaultcore.azure.net"]
  cosmosdb_dns_zone_id         = module.private_dns.zone_ids["privatelink.documents.azure.com"]
  storage_blob_dns_zone_id     = module.private_dns.zone_ids["privatelink.blob.core.windows.net"]
  document_intelligence_id     = module.document_intelligence.id
  document_intelligence_name   = module.document_intelligence.name
  document_intelligence_dns_zone_id = module.private_dns.zone_ids["privatelink.documents.azure.com"]
  tags                         = var.tags
}

module "appgateway" {
  source                      = "./modules/appgateway"
  resource_group_name         = azurerm_resource_group.main.name
  location                    = azurerm_resource_group.main.location
  environment                 = local.environment
  application_name            = var.application_name
  app_gateway_subnet_id       = module.network.app_gateway_subnet_id
  app_service_private_ip      = module.private_endpoints.app_service_private_ip
  app_service_default_hostname = module.appservice.default_hostname
  ssl_certificate_secret_id   = module.keyvault.certificate_secret_id
  public_dns_label            = local.app_gateway_dns_label
  user_assigned_identity_id   = ""
  tags                        = var.tags
}

module "entra_id" {
  source       = "./modules/entra-id"
  display_name = "cloudats-${local.environment}"
  homepage_url = "https://${local.app_gateway_public_fqdn}"
  logout_url   = "https://${local.app_gateway_public_fqdn}/"
  redirect_uris = ["https://${local.app_gateway_public_fqdn}/api/auth/redirect"]
}

resource "azurerm_role_assignment" "app_service_keyvault_secrets_user" {
  scope                = module.keyvault.key_vault_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = module.appservice.principal_id
}

resource "azurerm_role_assignment" "app_service_storage_blob_contributor" {
  scope                = module.storage.storage_account_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = module.appservice.principal_id
}

resource "azurerm_role_assignment" "app_service_cosmos_db_account_reader" {
  scope                = module.cosmosdb.account_id
  role_definition_name = "Cosmos DB Built-in Data Reader"
  principal_id         = module.appservice.principal_id
}

resource "azurerm_role_assignment" "app_gateway_key_vault_secrets_user" {
  scope                = module.keyvault.key_vault_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = module.appgateway.principal_id
}
