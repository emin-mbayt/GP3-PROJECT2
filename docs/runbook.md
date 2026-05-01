# Runbook — DOSE Platform

## Infrastructure Overview

| Resource | Value |
|----------|-------|
| Resource Group | `rg-proj2-dev-group-3` |
| Region | `northeurope` |
| App Gateway Public IP | `20.223.171.144` |
| App Gateway FQDN | `burger-proj2-dev-group-3.northeurope.cloudapp.azure.com` |
| vm-web (frontend) | `10.20.2.4` — no public IP |
| vm-api (backend) | `10.20.3.4` — no public IP |
| vm-ops (ops) | `10.20.5.4` — no public IP |
| SQL Server | `sql-proj2-dev-group-3-4niotw.database.windows.net` |
| Key Vault | `kv-grp3-4niotw` |

> All VMs have no public IPs. Access is via **Azure Bastion** only.

---

## VM Access — Azure Bastion

All VM access is done through Azure Bastion — no public IPs, no SSH key management from the internet.

**Portal:**
1. Azure Portal → Virtual Machines → select VM
2. Click **Connect → Bastion**
3. Enter `azureuser` + password
4. Browser-based SSH session opens

**Azure CLI:**
```bash
az network bastion ssh \
  --name bastion-proj2-dev-group-3 \
  --resource-group rg-proj2-dev-group-3 \
  --target-resource-id $(az vm show -g rg-proj2-dev-group-3 -n vm-ops-proj2-dev-group-3 --query id -o tsv) \
  --auth-type password \
  --username azureuser
```

---

## Common Operations

### Deploy frontend (from vm-ops via Bastion)
```bash
cd ~/GP3-PROJECT2 && git pull
cd config/ansible
ansible-playbook playbooks/site.yml --limit web --ask-vault-pass
```

### Deploy backend (from vm-ops via Bastion)
```bash
cd ~/GP3-PROJECT2 && git pull
cd config/ansible
ansible-playbook playbooks/site.yml --limit api --ask-vault-pass
```

### Check container status
```bash
ansible -i inventories/dev/hosts.ini all -m shell -a "docker ps -a" --ask-vault-pass
```

### Check container logs
```bash
ansible -i inventories/dev/hosts.ini web -m shell -a "docker logs burger-web --tail 50" --ask-vault-pass
ansible -i inventories/dev/hosts.ini api -m shell -a "docker logs burger-api --tail 50" --ask-vault-pass
```

### Restart a container
```bash
ansible -i inventories/dev/hosts.ini api -m shell -a "docker restart burger-api" --ask-vault-pass
```

### Update admin source CIDR (after IP change)
```bash
curl -s ifconfig.me  # get current IP
# Update envs/dev.tfvars → admin_source_cidr
cd infra/terraform
export TF_VAR_vm_admin_password="..."
terraform apply -var-file=envs/dev.tfvars
```

---

## Validate Health

### App Gateway backend health
```bash
az network application-gateway show-backend-health \
  --resource-group rg-proj2-dev-group-3 \
  --name appgw-proj2-dev-group-3 \
  --query "backendAddressPools[].backendHttpSettingsCollection[].servers[].{IP:address,Health:health}" \
  -o table
```

### Test endpoints
```bash
# Frontend
curl -s -o /dev/null -w "%{http_code}" http://burger-proj2-dev-group-3.northeurope.cloudapp.azure.com/

# Backend health
curl -s http://burger-proj2-dev-group-3.northeurope.cloudapp.azure.com/api/health

# Ingredients API
curl -s http://burger-proj2-dev-group-3.northeurope.cloudapp.azure.com/api/ingredients
```

### Verify SQL is private only
```bash
# From laptop — should timeout
curl --connect-timeout 5 https://sql-proj2-dev-group-3-4niotw.database.windows.net

# From vm-ops (via Bastion) — should resolve to private IP 10.20.4.x
nslookup sql-proj2-dev-group-3-4niotw.database.windows.net
```

---

## Troubleshooting

### AppGW showing Unhealthy
1. Connect to target VM via Bastion → `docker ps -a`
2. Check logs: `docker logs burger-web --tail 50`
3. Verify port mapping (frontend: `80:3000`, backend: `8080:8080`)
4. Check NSG allows traffic from AppGW subnet (`10.20.1.0/26`)

### Backend DB connection failed
1. `docker inspect burger-api | grep -A 30 Env` — verify env vars
2. `az sql db list --resource-group rg-proj2-dev-group-3 --server sql-proj2-dev-group-3-4niotw --query "[].name" -o tsv` — verify DB name
3. `nslookup sql-proj2-dev-group-3-4niotw.database.windows.net` from vm-ops — should return `10.20.4.x`

### CORS errors in browser
- Verify `CORS_ALLOWED_ORIGINS` includes the AppGW FQDN
- Redeploy backend via Ansible after updating

### Terraform state lock stuck
```bash
cd infra/terraform
terraform force-unlock <LOCK_ID>
# If that fails: add -lock=false to plan/apply
```

### Key Vault access denied
- `admin_source_cidr` in `dev.tfvars` must match your current public IP
- Run `curl -s ifconfig.me` then update and re-apply

---

## Destroy Infrastructure
```bash
cd infra/terraform
export TF_VAR_vm_admin_password="..."
terraform destroy -var-file=envs/dev.tfvars
```

> **Warning:** Key Vault has soft-delete. Purge manually before re-applying or next apply fails with `VaultAlreadyExists`.
```bash
az keyvault purge --name kv-grp3-4niotw
```
