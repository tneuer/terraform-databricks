#!/usr/bin/env bash
source ./sh_scripts/variables.sh
export ARM_ACCESS_KEY=$(az keyvault secret show --name $TF_SECRET_NAME --vault-name $TF_KEYVAULT_NAME --query value -o tsv);

terraform state rm azurerm_resource_group.rg
terraform state rm azurerm_key_vault.tfstatekv
terraform apply -destroy;
