output "public_ip_address" {
  description = "Application Gateway public IP address."
  value       = azurerm_public_ip.appgw.ip_address
}

output "public_ip_fqdn" {
  description = "Application Gateway Azure-assigned FQDN."
  value       = azurerm_public_ip.appgw.fqdn
}

output "appgw_id" {
  description = "Application Gateway resource ID."
  value       = azurerm_application_gateway.main.id
}
