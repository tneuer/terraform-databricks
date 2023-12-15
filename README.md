# README

## Requirements

- Azure CLI
- Terraform
- Databricks CLI

## Commands

sed -i 's/\r$//' ./sh_scripts/*
terraform force-unlock 1f10a15f-0d1a-3461-ca78-8235b9408f57

### Install Terraform Ubuntu

sudo apt-get install unzip
# https://www.terraform.io/downloads.html   Get version
wget https://releases.hashicorp.com/terraform/1.6.6/terraform_1.6.6_linux_amd64.zip
unzip terraform_1.0.7_linux_amd64.zip
sudo mv terraform /usr/local/bin/

### Install Github CLI Ubuntu
VERSION=`curl  "https://api.github.com/repos/cli/cli/releases/latest" | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/' | cut -c2-`
wget https://github.com/cli/cli/releases/download/v${VERSION}/gh_${VERSION}_linux_amd64.tar.gz
curl -sSL https://github.com/cli/cli/releases/download/v${VERSION}/gh_${VERSION}_linux_amd64.tar.gz -o gh_${VERSION}_linux_amd64.tar.gz
tar xvf gh_${VERSION}_linux_amd64.tar.gz
sudo cp gh_${VERSION}_linux_amd64/bin/gh /usr/local/bin/
sudo cp -r gh_${VERSION}_linux_amd64/share/man/man1/* /usr/share/man/man1/
rm -r gh_2.40.1_linux_amd64.tar.gz
rm -r gh_2.40.1_linux_amd64

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
- Connect via rotating sas token to state
