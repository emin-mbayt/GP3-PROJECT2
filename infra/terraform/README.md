# Terraform — Azure 3-Tier Infrastructure

## Prerequisites

- Terraform >= 1.9
- Azure CLI logged in (`az login`) with Contributor on the target subscription
- An SSH key pair — public key passed via `TF_VAR_ssh_public_key`

## First-time bootstrap (run once)

The backend storage account must exist before `terraform init` can use it.

```bash
cd infra/terraform/bootstrap
bash bootstrap.sh northeurope
# Copy the printed -backend-config values for the init step below.
```

## Initialise

```bash
cd infra/terraform

terraform init \
  -backend-config="resource_group_name=rg-tfstate" \
  -backend-config="storage_account_name=<sa-name-from-bootstrap>" \
  -backend-config="container_name=tfstate" \
  -backend-config="key=proj2-dev.tfstate"
```

To validate locally without a real backend (e.g. in CI):

```bash
terraform init -backend=false
```

## Workspaces

```bash
terraform workspace new dev
terraform workspace select dev
```

Use `proj2-dev.tfstate` / `proj2-prod.tfstate` as the backend key per workspace.

## Plan & Apply

```bash
export TF_VAR_ssh_public_key="$(cat ~/.ssh/id_rsa.pub)"

terraform plan  -var-file=envs/dev.tfvars -out=plan.out
terraform apply plan.out
```

Sensitive variables (`ssh_public_key`) must be passed via environment variables
or a secrets manager — never written into `.tfvars` files.

## Format & Validate

```bash
terraform fmt -recursive
terraform validate
```

Both commands must pass cleanly before raising a PR.

## Post-apply verification

### 1 — Private DNS resolves SQL inside the VNet

SSH into `vm-ops` (via Bastion or by temporarily allowing your IP in `nsg-ops`)
and run:

```bash
nslookup <sql_server_fqdn>
# Expected: resolves to 10.20.4.x, NOT a public Azure IP.
# If you see a public IP, the Private DNS zone VNet link is missing or wrong.
```

### 2 — Frontend reachable via App Gateway

```bash
curl -v http://$(terraform output -raw appgw_public_ip)/
# Expected: HTTP 200 from the React frontend.
```

### 3 — Backend reachable via App Gateway path routing

```bash
curl -v http://$(terraform output -raw appgw_public_ip)/api/health
# Expected: HTTP 200 from the Java API health endpoint.
```

### 4 — SQL not reachable from the public internet

```bash
# Run from your laptop (outside Azure):
curl --connect-timeout 5 https://$(terraform output -raw sql_server_fqdn)
# Expected: connection refused or timeout — public access is disabled.
```

### 5 — Key Vault not reachable from the public internet

```bash
curl --connect-timeout 5 $(terraform output -raw key_vault_name | \
  xargs -I{} echo "https://{}.vault.azure.net/")
# Expected: connection refused or timeout.
```

## Architecture overview

```
Internet
  │
  ▼
Application Gateway WAF v2 (snet-appgw 10.20.1.0/26)
  │ /          → pool-frontend
  │ /api/*     → pool-backend
  ▼                        ▼
vm-web (snet-web)      vm-api (snet-api)
10.20.2.0/24           10.20.3.0/24
                            │
                            ▼
                    SQL Private Endpoint (snet-data 10.20.4.0/27)
                    KV  Private Endpoint (snet-kv   10.20.4.32/27)

snet-ops 10.20.5.0/27 → SonarQube + GH Actions runner
```

## .gitignore

Add to your repo root `.gitignore`:

```
**/.terraform/
*.tfstate
*.tfstate.backup
*.tfplan
```

The `.terraform.lock.hcl` file should be committed so all team members use the
same provider versions.
