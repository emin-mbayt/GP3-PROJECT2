output "appgw_public_ip" {
  description = "Application Gateway public IP address."
  value       = module.appgw.public_ip_address
}

output "appgw_fqdn" {
  description = "Application Gateway public FQDN (Azure-assigned DNS)."
  value       = module.appgw.public_ip_fqdn
}

output "sql_server_fqdn" {
  description = "Azure SQL Server fully qualified domain name."
  value       = module.data.sql_server_fqdn
}

output "key_vault_name" {
  description = "Key Vault name."
  value       = module.keyvault.key_vault_name
}

output "log_analytics_workspace_id" {
  description = "Log Analytics workspace resource ID."
  value       = module.observability.workspace_id
}

output "app_insights_connection_string" {
  description = "Application Insights connection string."
  value       = module.observability.app_insights_connection_string
  sensitive   = true
}

output "vm_web_private_ip" {
  description = "Frontend VM private IP address."
  value       = module.compute.vm_web_private_ip
}

output "vm_api_private_ip" {
  description = "Backend VM private IP address."
  value       = module.compute.vm_api_private_ip
}

output "vm_ops_private_ip" {
  description = "Ops VM private IP address."
  value       = module.ops.vm_ops_private_ip
}
