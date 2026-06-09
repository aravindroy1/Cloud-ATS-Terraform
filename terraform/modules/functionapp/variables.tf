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

variable "function_app_plan_sku" {
  type = string
}

variable "function_app_runtime_version" {
  type = string
}

variable "app_integration_subnet_id" {
  type = string
}

variable "storage_account_id" {
  type = string
}

variable "storage_account_name" {
  type = string
}

variable "storage_account_access_key" {
  type      = string
  sensitive = true
}

variable "storage_account_connection_string" {
  type      = string
  sensitive = true
}

variable "storage_container_name" {
  type = string
}

variable "key_vault_id" {
  type = string
}

variable "key_vault_name" {
  type = string
}

variable "cosmosdb_mongo_connection_string" {
  type      = string
  sensitive = true
}

variable "document_intelligence_endpoint" {
  type = string
}

variable "document_intelligence_key" {
  type      = string
  sensitive = true
}

variable "app_dashboard_url" {
  type = string
}

variable "application_insights_connection_string" {
  type      = string
  sensitive = true
}

variable "smtp_host" {
  type      = string
  nullable  = true
  sensitive = true
}

variable "smtp_port" {
  type = number
}

variable "smtp_user" {
  type      = string
  nullable  = true
  sensitive = true
}

variable "smtp_pass" {
  type      = string
  nullable  = true
  sensitive = true
}

variable "smtp_from" {
  type = string
}

variable "tags" {
  type = map(string)
}

