variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "environment" {
  type = string
}

variable "data_subnet_id" {
  type = string
}

variable "app_service_id" {
  type = string
}

variable "app_service_name" {
  type = string
}

variable "key_vault_id" {
  type = string
}

variable "key_vault_name" {
  type = string
}

variable "cosmosdb_id" {
  type = string
}

variable "cosmosdb_name" {
  type = string
}

variable "storage_account_id" {
  type = string
}

variable "storage_account_name" {
  type = string
}

variable "app_service_dns_zone_id" {
  type = string
}

variable "key_vault_dns_zone_id" {
  type = string
}

variable "cosmosdb_dns_zone_id" {
  type = string
}

variable "storage_blob_dns_zone_id" {
  type = string
}

variable "storage_queue_dns_zone_id" {
  type = string
}

variable "storage_table_dns_zone_id" {
  type = string
}

variable "storage_file_dns_zone_id" {
  type = string
}

variable "document_intelligence_id" {
  type = string
}

variable "document_intelligence_name" {
  type = string
}

variable "document_intelligence_dns_zone_id" {
  type = string
}

variable "tags" {
  type = map(string)
}
