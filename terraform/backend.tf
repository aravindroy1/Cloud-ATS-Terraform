terraform {
  backend "azurerm" {
    resource_group_name  = "cloudats-tfstate-rg"
    storage_account_name = "cloudatstfstate001"
    container_name       = "tfstate"
    key                  = "cloud-ats-${terraform.workspace}.tfstate"
  }
}
