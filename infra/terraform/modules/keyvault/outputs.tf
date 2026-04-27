output "key_vault_id" {
  description = "Key Vault resource ID (consumed by data module to write secrets)."
  value       = azurerm_key_vault.main.id
}

output "key_vault_name" {
  description = "Key Vault name."
  value       = azurerm_key_vault.main.name
}

output "key_vault_uri" {
  description = "Key Vault vault URI (https://<name>.vault.azure.net/)."
  value       = azurerm_key_vault.main.vault_uri
}
