variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "environment" {
  type = string
}

variable "application_name" {
  type = string
}

variable "service_plan_sku" {
  type = string
}

variable "app_service_runtime" {
  type = string
}

variable "app_integration_subnet_id" {
  type = string
}

variable "key_vault_id" {
  type = string
}

variable "storage_account_id" {
  type = string
}

variable "storage_account_name" {
  type = string
}

variable "storage_container_name" {
  type = string
}

variable "cosmosdb_endpoint" {
  type = string
}

variable "cosmosdb_mongo_connection_string" {
  type      = string
  sensitive = true
}

variable "key_vault_name" {
  type = string
}

variable "app_insights_connection_string" {
  type      = string
  sensitive = true
}

variable "app_insights_instrumentation_key" {
  type      = string
  sensitive = true
}

variable "entra_client_id" {
  type = string
}

variable "entra_client_secret" {
  type      = string
  sensitive = true
}

variable "entra_tenant_id" {
  type = string
}

variable "entra_redirect_uri" {
  type = string
}

variable "jwt_secret" {
  type      = string
  sensitive = true
}

variable "tags" {
  type = map(string)
}
