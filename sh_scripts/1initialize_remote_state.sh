#!/usr/bin/env bash
source ./sh_scripts/variables.sh

echo Deploying resource group $TF_RESOURCE_GROUP_NAME...
az group create --name $TF_RESOURCE_GROUP_NAME --location $LOCATION

echo Deploying blob storage $TF_STORAGE_ACCOUNT_NAME...
az storage account create --resource-group $TF_RESOURCE_GROUP_NAME --name $TF_STORAGE_ACCOUNT_NAME --sku STANDARD_LRS --encryption-services blob
az storage container create --name $TF_CONTAINER_NAME --account-name $TF_STORAGE_ACCOUNT_NAME --auth-mode login

echo Deploying keyvault $TF_KEYVAULT_NAME...
az keyvault create --name $TF_KEYVAULT_NAME --resource-group $TF_RESOURCE_GROUP_NAME --location $LOCATION
az keyvault secret set --name $TF_SECRET_NAME --vault-name $TF_KEYVAULT_NAME --value $(az storage account keys list --resource-group $TF_RESOURCE_GROUP_NAME --account-name $TF_STORAGE_ACCOUNT_NAME --query '[0].value' -o tsv)
