source ./sh_scripts/variables.sh
export ARM_ACCESS_KEY=$(az keyvault secret show --name $TF_SECRET_NAME --vault-name $TF_KEYVAULT_NAME --query value -o tsv);

terraform init -backend-config="./configs/config_dev.azure.tfbackend";
terraform import 'module.base-setup.azurerm_resource_group.base_rg' /subscriptions/$SUBSCRIPTION_ID/resourceGroups/$BUILD_RESOURCE_GROUP_NAME_RESOURCES
terraform import 'module.base-setup.azurerm_key_vault.tfstatekv' /subscriptions/$SUBSCRIPTION_ID/resourceGroups/$BUILD_RESOURCE_GROUP_NAME_RESOURCES/providers/Microsoft.KeyVault/vaults/tfstatekv
