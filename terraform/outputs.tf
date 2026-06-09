output "app_gateway_public_ip" {
  value = module.appgateway.public_ip_address
}

output "app_gateway_dns" {
  value = module.appgateway.public_ip_fqdn
}

output "app_service_name" {
  value = module.appservice.app_service_name
}

output "key_vault_name" {
  value = module.keyvault.key_vault_name
}

output "cosmosdb_endpoint" {
  value = module.cosmosdb.endpoint
}

output "storage_account_name" {
  value = module.storage.storage_account_name
}
