project_name = "proj2"
environment  = "dev"
location     = "northeurope"
owner        = "ironhack-team"

# Replace with your actual IP before applying: curl -s ifconfig.me
admin_source_cidr = "0.0.0.0/0"

sql_admin_login = "sqladmin"

vm_size_web = "Standard_B2s"
vm_size_api = "Standard_B2s"
vm_size_ops = "Standard_B2s"

sql_sku = "S0"
kv_sku  = "standard"

# ssh_public_key is passed via TF_VAR_ssh_public_key env var — not stored here.
