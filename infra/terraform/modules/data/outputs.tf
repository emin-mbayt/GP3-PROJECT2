output "sql_server_fqdn" {
  description = "Fully qualified domain name of the SQL Server."
  value       = azurerm_mssql_server.main.fully_qualified_domain_name
}

output "sql_admin_password" {
  description = "Generated SQL administrator password (sensitive)."
  value       = random_password.sql.result
  sensitive   = true
}

output "sql_db_id" {
  description = "Azure SQL database resource ID."
  value       = azurerm_mssql_database.main.id
}
