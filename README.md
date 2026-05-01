# DOSE — Personalized Supplement Protocol Platform

Full-stack supplement subscription app deployed on Azure 3-tier infrastructure. React/TypeScript frontend + Spring Boot backend + Azure IaC (Terraform) + Ansible configuration management + GitHub Actions CI/CD.

**Live URL:** `http://burger-proj2-dev-group-3.northeurope.cloudapp.azure.com`

---

## What is DOSE?

DOSE is a premium, personalized supplement subscription platform. Users build a custom protocol stack from 20 science-backed supplements across four goal categories — Energy, Focus, Immunity, Longevity — then subscribe for monthly delivery.

---

## Prerequisites

### Tools

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.9
- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) >= 2.50
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/) >= 2.17
- Docker (for local development)
- Java 21 + Maven (backend local dev)
- Node.js 20 (frontend local dev)

### Azure Requirements

- Azure subscription with **Contributor** role
- VM core quota: minimum **6 vCPUs** (`Standard_D2s_v3`) in `northeurope`
- Registered providers: `Microsoft.Compute`, `Microsoft.Network`, `Microsoft.Sql`, `Microsoft.KeyVault`

### GitHub Secrets Required

| Secret               |
| -------------------- |
| `DOCKERHUB_USERNAME` |
| `DOCKERHUB_TOKEN`    |
| `SONAR_TOKEN`        |
| `SONAR_HOST_URL`     |
| `VITE_API_BASE_URL`  |
| `ANSIBLE_VAULT_PASS` |

---

## 1. Provision Infrastructure (Terraform)

```bash
# One-time bootstrap (creates Terraform state storage)
cd infra/terraform/bootstrap
bash bootstrap.sh northeurope

# Init
cd infra/terraform
terraform init -backend-config=backend.hcl

# Update your IP before every apply
curl -s ifconfig.me  # copy output to admin_source_cidr in envs/dev.tfvars

# Plan & Apply
export TF_VAR_vm_admin_password="YourPassword123!"
terraform plan -var-file=envs/dev.tfvars -out=plan.out
terraform apply plan.out
```

Key outputs after apply:

```bash
terraform output appgw_public_ip      # App Gateway IP
terraform output appgw_fqdn           # App Gateway DNS
terraform output sql_server_fqdn      # SQL Server FQDN
```

---

## 2. Configure VMs (Ansible)

```bash
# Connect to vm-ops via Azure Bastion
# Azure Portal → Virtual Machines → vm-ops-proj2-dev-group-3 → Connect → Bastion
# Enter username: azureuser + password

# Clone repo
git clone https://github.com/emin-mbayt/GP3-PROJECT2.git
cd GP3-PROJECT2/config/ansible

# Fill in vault values
ansible-vault edit inventories/dev/group_vars/all/vault.yml

# Test connectivity
ansible-playbook playbooks/ping.yml --ask-vault-pass

# Deploy all
ansible-playbook playbooks/site.yml --ask-vault-pass
```

### Vault variables required

```yaml
vault_vm_password: "..."
vault_dockerhub_username: "..."
vault_dockerhub_password: "..."
vault_db_host: "sql-proj2-dev-group-3-4niotw.database.windows.net"
vault_db_name: "sqldb-proj2-dev-group-3"
vault_db_username: "sqladmin"
vault_db_password: "..."
```

---

## 3. Deploy (GitHub Actions)

Two pipelines trigger automatically on push to `main`:

| Pipeline                  | Trigger               | Stages                                                                    |
| ------------------------- | --------------------- | ------------------------------------------------------------------------- |
| `backend_build_push.yml`  | `backend/**` changes  | SonarQube → Docker build+push → Ansible deploy to vm-api                  |
| `frontend_build_push.yml` | `frontend/**` changes | Tests+coverage → SonarQube → Docker build+push → Ansible deploy to vm-web |

Manual trigger: GitHub → Actions → select pipeline → **Run workflow**

---

## 4. Validate

### Check AppGW backend health

```bash
az network application-gateway show-backend-health \
  --resource-group rg-proj2-dev-group-3 \
  --name appgw-proj2-dev-group-3 \
  --query "backendAddressPools[].backendHttpSettingsCollection[].servers[].{IP:address,Health:health}" \
  -o table
```

### Test endpoints

```bash
BASE="http://burger-proj2-dev-group-3.northeurope.cloudapp.azure.com"

# Frontend
curl -s -o /dev/null -w "%{http_code}" $BASE/

# API health
curl $BASE/api/health

# Supplements
curl $BASE/api/ingredients

# Verify SQL is NOT publicly reachable
curl --connect-timeout 5 https://sql-proj2-dev-group-3-4niotw.database.windows.net
# Expected: timeout
```

### Verify private DNS (from vm-ops)

```bash
nslookup sql-proj2-dev-group-3-4niotw.database.windows.net
# Expected: resolves to 10.20.4.x (private IP, not public Azure IP)
```

---

## Architecture

```
Internet
    │
    ▼
App Gateway WAF v2 (snet-appgw 10.20.1.0/26)
    │ /          → vm-web  (snet-web  10.20.2.0/24)  Docker: gp3-front :80
    │ /api/*     → vm-api  (snet-api  10.20.3.0/24)  Docker: gp3      :8080
                               │
                               ├─ SQL Private Endpoint (snet-data 10.20.4.0/27)
                               └─ KV  Private Endpoint (snet-kv   10.20.4.32/27)

snet-ops (10.20.5.0/27) — vm-ops: SonarQube + GitHub Actions runner + Ansible (access via Azure Bastion)
```

---

## Project Structure

```
├── frontend/                   # React + TypeScript + Vite (DOSE UI)
├── backend/                    # Spring Boot Java 21
├── infra/
│   └── terraform/
│       ├── modules/
│       │   ├── network/        # VNet, subnets, NSGs, Private DNS
│       │   ├── compute/        # vm-web, vm-api
│       │   ├── ops/            # vm-ops (SonarQube + GH runner)
│       │   ├── data/           # Azure SQL + private endpoint
│       │   ├── keyvault/       # Key Vault + private endpoint
│       │   ├── appgw/          # App Gateway WAF v2
│       │   └── observability/  # Log Analytics + App Insights
│       └── envs/
│           └── dev.tfvars
├── config/
│   └── ansible/
│       ├── inventories/dev/
│       ├── playbooks/
│       └── roles/{common,web,api}
├── .github/workflows/
│   ├── backend_build_push.yml
│   └── frontend_build_push.yml
└── docs/
    ├── architecture-diagram.md
    ├── runbook.md
    └── demo-script.md
```

---

## Further Reading

- [Runbook](docs/runbook.md) — operations, troubleshooting, common tasks
- [Demo Script](docs/demo-script.md) — presentation guide
