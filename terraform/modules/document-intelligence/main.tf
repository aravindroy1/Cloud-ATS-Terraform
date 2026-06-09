resource "azurerm_cognitive_account" "main" {
  name                          = "di-${var.application_name}-${var.environment}"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  kind                          = "FormRecognizer"
  sku_name                      = "S0"
  custom_subdomain_name         = "di-${var.application_name}-${var.environment}"
  public_network_access_enabled = false
  tags                          = var.tags

  network_acls {
    default_action = "Deny"
  }
}
