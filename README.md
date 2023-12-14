# README

## Requirements

- PowerShell
- Azure CLI
- Terraform
- Databricks CLI

## Commands

### Checks & Apply

terraform init -backend-config="./configs/config_dev.azure.tfbackend";
terraform fmt -recursive;
terraform validate;
terraform plan -var-file="./variables/dev.tfvars";
terraform apply -var-file="./variables/dev.tfvars" -auto-approve;

### Show & List

terraform state list
terraform state show azurerm_resource_group.example

## Description

- main.tf: Entry point for the terraform deployment.
- terraform.tfvars: Global variables. Used in every environment.
- variables.tf: Variable declarations on a global level.
- initiate_remote_state.azcli: Creates storage account for remote states.
- variables/*: Environment specific variables.
- configs/*: Environment specific configurations. Inclduing remote state server.
- modules/*: Modules of the terraform main.tf file.

## Manual setup

- Run PowerShell from root: .\pwsh_scripts\initialize_remote_state.ps1
- Run PowerShell from root: .\pwsh_scripts\initialize_github_sp.ps1
- Copy credentials returned from previous command to Github secret with name "AZURE_TERRAFORM_CREDENTIALS"

## Next steps

- Make diagram
- Deploy networks & databricks environment using terraform
- Databricks CLI tutorial
