data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "main" {
  # KV names must be globally unique, 3-24 chars, alphanumeric + hyphens.
  name                          = "kv-${var.prefix}-${var.suffix}"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  sku_name                      = var.kv_sku
  rbac_authorization_enabled    = true
  soft_delete_retention_days    = 90
  purge_protection_enabled      = true
  public_network_access_enabled = false
  tags                          = var.tags

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
    # ip_rules and virtual_network_subnet_ids left empty — all access via PE.
  }
}

resource "azurerm_private_endpoint" "kv" {
  name                = "pe-kv-${var.prefix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id
  tags                = var.tags

  private_service_connection {
    name                           = "psc-kv-${var.prefix}"
    private_connection_resource_id = azurerm_key_vault.main.id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "dnszg-kv"
    private_dns_zone_ids = [var.private_dns_zone_id_kv]
  }
}

# Uncomment to grant the Terraform runner Secrets Officer access if running
# from a service principal with a known object ID:
#
# resource "azurerm_role_assignment" "tf_secrets_officer" {
#   scope                = azurerm_key_vault.main.id
#   role_definition_name = "Key Vault Secrets Officer"
#   principal_id         = data.azurerm_client_config.current.object_id
# }
