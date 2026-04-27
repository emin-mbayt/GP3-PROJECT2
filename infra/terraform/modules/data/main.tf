resource "random_password" "sql" {
  length           = 24
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "azurerm_mssql_server" "main" {
  # SQL Server names must be globally unique — suffix provides uniqueness.
  name                          = "sql-${var.prefix}-${var.suffix}"
  resource_group_name           = var.resource_group_name
  location                      = var.location
  version                       = "12.0"
  administrator_login           = var.sql_admin_login
  administrator_login_password  = random_password.sql.result
  minimum_tls_version           = "1.2"
  public_network_access_enabled = false
  tags                          = var.tags

  # TODO: Add Azure AD administrator for passwordless auth:
  # azuread_administrator {
  #   login_username = "aad-admin-group-name"
  #   object_id      = var.aad_admin_object_id
  # }
}

resource "azurerm_mssql_database" "main" {
  name      = "sqldb-${var.prefix}"
  server_id = azurerm_mssql_server.main.id
  sku_name  = var.sql_sku
  tags      = var.tags
}

resource "azurerm_private_endpoint" "sql" {
  name                = "pe-sql-${var.prefix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id
  tags                = var.tags

  private_service_connection {
    name                           = "psc-sql-${var.prefix}"
    private_connection_resource_id = azurerm_mssql_server.main.id
    subresource_names              = ["sqlServer"]
    is_manual_connection           = false
  }

  # private_dns_zone_group auto-registers the A record in the Private DNS zone.
  # This eliminates the need for a separate azurerm_private_dns_a_record.
  private_dns_zone_group {
    name                 = "dnszg-sql"
    private_dns_zone_ids = [var.private_dns_zone_id_sql]
  }
}

# Store the generated password in Key Vault.
# Prerequisite: the Terraform runner must hold the Key Vault Secrets Officer
# role on the vault before apply. Assign via:
#   az role assignment create \
#     --role "Key Vault Secrets Officer" \
#     --assignee <terraform-sp-object-id> \
#     --scope <key_vault_id>
resource "azurerm_key_vault_secret" "sql_password" {
  name         = "sql-admin-password"
  value        = random_password.sql.result
  key_vault_id = var.key_vault_id

  depends_on = [azurerm_mssql_server.main]
}

resource "azurerm_monitor_diagnostic_setting" "sql_db" {
  name                       = "diag-sqldb-${var.prefix}"
  target_resource_id         = azurerm_mssql_database.main.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category_group = "allLogs"
  }

  enabled_metric {
    category = "Basic"
  }
}
