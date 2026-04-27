# Terraform Workspaces
# ---------------------
# Use workspaces to track environment state independently:
#
#   terraform workspace new dev
#   terraform workspace select dev
#   terraform apply -var-file=envs/dev.tfvars \
#     -backend-config="key=proj2-dev.tfstate"
#
# The workspace name is informational; the .tfvars file drives actual values.
# Each workspace writes to its own state key in the backend container.

# Stable 6-char suffix for globally-unique Azure resource names (SQL, KV).
# This is created once and stored in state — the suffix never changes on re-apply.
resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

resource "azurerm_resource_group" "main" {
  name     = "rg-${local.prefix}"
  location = var.location
  tags     = local.tags
}

# 1. Network — VNet, subnets, NSGs, Private DNS zones
module "network" {
  source = "./modules/network"

  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  tags                = local.tags
  prefix              = local.prefix
  admin_source_cidr   = var.admin_source_cidr
}

# 2. Observability — Log Analytics + App Insights
module "observability" {
  source = "./modules/observability"

  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  tags                = local.tags
  prefix              = local.prefix
}

# 3. Key Vault — private, RBAC-enabled
module "keyvault" {
  source = "./modules/keyvault"

  resource_group_name    = azurerm_resource_group.main.name
  location               = var.location
  tags                   = local.tags
  prefix                 = local.prefix
  suffix                 = local.suffix
  subnet_id              = module.network.snet_kv_id
  private_dns_zone_id_kv = module.network.private_dns_zone_id_kv
  kv_sku                 = var.kv_sku
}

# 4. Data — SQL Server + Private Endpoint, password written to KV
module "data" {
  source = "./modules/data"

  resource_group_name        = azurerm_resource_group.main.name
  location                   = var.location
  tags                       = local.tags
  prefix                     = local.prefix
  suffix                     = local.suffix
  subnet_id                  = module.network.snet_data_id
  private_dns_zone_id_sql    = module.network.private_dns_zone_id_sql
  sql_admin_login            = var.sql_admin_login
  sql_sku                    = var.sql_sku
  key_vault_id               = module.keyvault.key_vault_id
  log_analytics_workspace_id = module.observability.workspace_id
}

# 5. Compute — frontend + backend VMs (no public IPs)
module "compute" {
  source = "./modules/compute"

  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  tags                = local.tags
  prefix              = local.prefix
  subnet_web_id       = module.network.snet_web_id
  subnet_api_id       = module.network.snet_api_id
  ssh_public_key      = var.ssh_public_key
  vm_size_web         = var.vm_size_web
  vm_size_api         = var.vm_size_api
}

# 6. Ops — SonarQube + GitHub Actions runner VM
module "ops" {
  source = "./modules/ops"

  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  tags                = local.tags
  prefix              = local.prefix
  subnet_ops_id       = module.network.snet_ops_id
  ssh_public_key      = var.ssh_public_key
  vm_size_ops         = var.vm_size_ops
}

# 7. App Gateway — WAF v2, routes / → frontend, /api/* → backend
module "appgw" {
  source = "./modules/appgw"

  resource_group_name        = azurerm_resource_group.main.name
  location                   = var.location
  tags                       = local.tags
  prefix                     = local.prefix
  subnet_id                  = module.network.snet_appgw_id
  frontend_private_ip        = module.compute.vm_web_private_ip
  backend_private_ip         = module.compute.vm_api_private_ip
  log_analytics_workspace_id = module.observability.workspace_id
}
