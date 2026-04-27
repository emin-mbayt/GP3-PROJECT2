#!/usr/bin/env bash
# Creates the Azure storage account used for Terraform remote state.
# Run this ONCE manually before the first `terraform init`.
# Requires: az cli logged in with Contributor on the target subscription.

set -euo pipefail

LOCATION="${1:-northeurope}"
RG="rg-tfstate"
# Storage account names must be globally unique, 3-24 lowercase alphanumeric.
SA_NAME="sttfstateproj2$(head -c 4 /dev/urandom | xxd -p)"
CONTAINER="tfstate"

echo "Creating resource group: ${RG}"
az group create \
  --name "${RG}" \
  --location "${LOCATION}" \
  --output none

echo "Creating storage account: ${SA_NAME}"
az storage account create \
  --name "${SA_NAME}" \
  --resource-group "${RG}" \
  --location "${LOCATION}" \
  --sku Standard_LRS \
  --kind StorageV2 \
  --min-tls-version TLS1_2 \
  --allow-blob-public-access false \
  --output none

echo "Enabling versioning for state recovery"
az storage account blob-service-properties update \
  --account-name "${SA_NAME}" \
  --resource-group "${RG}" \
  --enable-versioning true \
  --output none

echo "Creating container: ${CONTAINER}"
az storage container create \
  --name "${CONTAINER}" \
  --account-name "${SA_NAME}" \
  --auth-mode login \
  --output none

echo ""
echo "Bootstrap complete. Use these values for terraform init:"
echo "  -backend-config=\"resource_group_name=${RG}\""
echo "  -backend-config=\"storage_account_name=${SA_NAME}\""
echo "  -backend-config=\"container_name=${CONTAINER}\""
echo "  -backend-config=\"key=proj2-dev.tfstate\""
