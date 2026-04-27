terraform {
  backend "azurerm" {
    # All values are supplied via -backend-config flags during `terraform init`
    # so that this file contains no secrets and is safe to commit.
    #
    # Example:
    #   terraform init \
    #     -backend-config="resource_group_name=rg-tfstate" \
    #     -backend-config="storage_account_name=sttfstateproj2xxxx" \
    #     -backend-config="container_name=tfstate" \
    #     -backend-config="key=proj2.tfstate"
    #
    # The storage account is created once manually via bootstrap/bootstrap.sh.
  }
}
