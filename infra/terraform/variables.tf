variable "project_name" {
  description = "Short project identifier used in resource names."
  type        = string
  default     = "proj2"
}

variable "environment" {
  description = "Deployment environment (dev | prod)."
  type        = string

  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "environment must be 'dev' or 'prod'."
  }
}

variable "location" {
  description = "Azure region for all resources."
  type        = string
  default     = "northeurope"
}

variable "owner" {
  description = "Value for the 'owner' tag applied to every resource."
  type        = string
  default     = "ironhack-team"
}

variable "admin_source_cidr" {
  description = "CIDR block allowed SSH access to the ops subnet NSG."
  type        = string
}

variable "vm_admin_password" {
  description = "Password for the azureuser account on all VMs. Pass via TF_VAR_vm_admin_password."
  type        = string
  sensitive   = true
}

variable "sql_admin_login" {
  description = "SQL Server administrator login name."
  type        = string
  default     = "sqladmin"
}

variable "tags_extra" {
  description = "Additional tags merged into the common tag map."
  type        = map(string)
  default     = {}
}

variable "vm_size_web" {
  description = "VM size for the frontend VM."
  type        = string
  default     = "Standard_B2s"
}

variable "vm_size_api" {
  description = "VM size for the backend VM."
  type        = string
  default     = "Standard_B2s"
}

variable "vm_size_ops" {
  description = "VM size for the ops VM (SonarQube + GH runner)."
  type        = string
  default     = "Standard_B2s"
}

variable "sql_sku" {
  description = "Azure SQL Database service tier (e.g. S0, S2, GP_Gen5_2)."
  type        = string
  default     = "S0"
}

variable "kv_sku" {
  description = "Key Vault SKU (standard | premium)."
  type        = string
  default     = "standard"

  validation {
    condition     = contains(["standard", "premium"], var.kv_sku)
    error_message = "kv_sku must be 'standard' or 'premium'."
  }
}

variable "alert_email" {
  description = "Email address for monitoring alert notifications."
  type        = string
  default     = "ichihiroy9@gmail.com"
}
