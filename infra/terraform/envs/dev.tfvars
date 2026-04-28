project_name = "proj2"
environment  = "dev"
location     = "northeurope"
owner        = "ironhack-team"

# Replace with your actual IP before applying: curl -s ifconfig.me
admin_source_cidr = "37.114.183.169"

sql_admin_login = "sqladmin"

vm_size_web = "Standard_D2s_v3"
vm_size_api = "Standard_D2s_v3"
vm_size_ops = "Standard_D2s_v3"

sql_sku = "S0"
kv_sku  = "standard"

# ssh_public_key is passed via TF_VAR_ssh_public_key env var — not stored here.
