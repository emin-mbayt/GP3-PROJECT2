variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "prefix" {
  type = string
}

variable "suffix" {
  description = "Random suffix for globally-unique SQL Server name."
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for the SQL Private Endpoint (snet-data)."
  type        = string
}

variable "private_dns_zone_id_sql" {
  description = "Private DNS zone ID for privatelink.database.windows.net."
  type        = string
}

variable "sql_admin_login" {
  description = "SQL Server administrator login name."
  type        = string
}

variable "sql_sku" {
  description = "Azure SQL Database service tier (e.g. S0, S2)."
  type        = string
}

variable "key_vault_id" {
  description = "Key Vault resource ID — SQL password is written here as a secret."
  type        = string
}

variable "log_analytics_workspace_id" {
  description = "Log Analytics workspace resource ID for diagnostic settings."
  type        = string
}
