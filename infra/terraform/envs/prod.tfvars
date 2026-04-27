project_name = "proj2"
environment  = "prod"
location     = "northeurope"
owner        = "ironhack-team"

# Replace with your actual IP before applying.
admin_source_cidr = "0.0.0.0/0"

sql_admin_login = "sqladmin"

vm_size_web = "Standard_D2s_v3"
vm_size_api = "Standard_D2s_v3"
vm_size_ops = "Standard_B2s"

sql_sku = "S2"
kv_sku  = "premium"

# ssh_public_key is passed via TF_VAR_ssh_public_key env var — not stored here.
