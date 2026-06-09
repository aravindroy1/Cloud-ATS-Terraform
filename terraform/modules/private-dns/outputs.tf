output "zone_ids" {
  value = {
    for name, zone in azurerm_private_dns_zone.main : name => zone.id
  }
}

output "zone_names" {
  value = {
    for name, zone in azurerm_private_dns_zone.main : name => zone.name
  }
}

