output "vnet_id" {
  value = azurerm_virtual_network.main.id
}

output "snet_appgw_id" {
  value = azurerm_subnet.appgw.id
}

output "snet_web_id" {
  value = azurerm_subnet.web.id
}

output "snet_api_id" {
  value = azurerm_subnet.api.id
}

output "snet_data_id" {
  value = azurerm_subnet.data.id
}

output "snet_kv_id" {
  value = azurerm_subnet.kv.id
}

output "snet_ops_id" {
  value = azurerm_subnet.ops.id
}

output "private_dns_zone_id_sql" {
  value = azurerm_private_dns_zone.sql.id
}

output "private_dns_zone_id_kv" {
  value = azurerm_private_dns_zone.kv.id
}
