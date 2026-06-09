resource "azurerm_log_analytics_workspace" "main" {
  name                = var.log_analytics_workspace_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = var.log_analytics_retention_days
  tags                = var.tags
}

resource "azurerm_application_insights" "main" {
  name                        = var.application_insights_name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  application_type            = "web"
  workspace_resource_id       = azurerm_log_analytics_workspace.main.id
  tags                        = var.tags
}
