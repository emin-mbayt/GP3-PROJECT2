# Demo Script — DOSE Platform

## 1. Show the Live App (2 min)

Open browser → `https://dose.software`

- Browse supplements by goal filter (Energy / Focus / Immunity / Longevity)
- Click a **Starter Protocol** preset (e.g. "The Executive") — watch protocol stack populate instantly
- Add individual supplements to customize the stack
- Watch **Metrics Panel** update live — coverage bars, supplement count, monthly cost
- Click **Subscribe** → goes to cart ("My Stack")
- Proceed to Checkout → fill in details → confirm order
- Check **My Shipments** for order history

**Talking point:** "This is DOSE — a personalized supplement subscription platform. Frontend on vm-web, API on vm-api, supplement data persisted in Azure SQL — all behind App Gateway WAF v2. The UX is designed to feel like a fundable startup product, not a student project."

---

## 2. Show the Infrastructure (2 min)

**Azure Portal → Resource Group `rg-proj2-dev-group-3`**

Point out:
- App Gateway → Backend health (both Healthy)
- SQL Server → Networking → public access Disabled, private endpoint shown
- Key Vault → Networking → private endpoint, IP allowlist for runner
- 3 VMs — no public IPs, all access via Azure Bastion

**Talking point:** "Zero trust network — SQL and Key Vault only reachable inside the VNet via private endpoints. No VM has a public IP — all admin access goes through Azure Bastion."

---

## 3. Show CI/CD Pipeline (2 min)

**GitHub → Actions tab**

Trigger a dummy push or show last successful run:
- Backend pipeline: SonarQube scan → Quality Gate → Docker build+push → Ansible deploy
- Frontend pipeline: Tests+coverage → SonarQube scan → Docker build+push → Ansible deploy

**Talking point:** "Code goes through a quality gate before it can deploy. SonarQube blocks bad code from reaching production. Docker images are versioned by commit SHA and pushed to DockerHub, then Ansible pulls and restarts containers on the VMs."

---

## 4. Show SonarQube (1 min)

Access via Azure Bastion → vm-ops → `http://localhost:9000`

Show:
- `gp3-project2` (backend) — test coverage, code smells, security issues
- `gp3-project2-web` (frontend) — same

**Talking point:** "Self-hosted SonarQube on the ops VM inside the VNet — no public exposure, accessible only from within the VNet via Bastion."

---

## 5. Show IaC — Terraform (1 min)

```bash
cd infra/terraform
terraform show | head -50
```

Or show the module structure in the repo.

**Talking point:** "Entire infrastructure is code — VNet, subnets, NSGs, App Gateway, SQL, Key Vault, VMs. Reproducible in any region with one command."

---

## 6. Show Configuration Management — Ansible (1 min)

```bash
# Connect via Azure Bastion → vm-ops
cd ~/GP3-PROJECT2/config/ansible
cat inventories/dev/hosts.ini
cat playbooks/site.yml
```

**Talking point:** "Ansible handles all VM configuration and Docker deployments. Secrets managed via ansible-vault — never stored in plaintext."

---

## Sample curl Commands

```bash
BASE="https://dose.software"

# Health check
curl $BASE/api/health

# Get all supplements
curl $BASE/api/ingredients

# Get supplements by category
curl $BASE/api/ingredients/energy
curl $BASE/api/ingredients/focus

# Get order history
curl $BASE/api/orders/history
```
