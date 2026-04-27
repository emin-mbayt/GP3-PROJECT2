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
  description = "Random suffix for globally-unique Key Vault name."
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for the Key Vault Private Endpoint (snet-kv)."
  type        = string
}

variable "private_dns_zone_id_kv" {
  description = "Private DNS zone ID for privatelink.vaultcore.azure.net."
  type        = string
}

variable "kv_sku" {
  description = "Key Vault SKU (standard | premium)."
  type        = string
}
