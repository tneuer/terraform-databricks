#!/usr/bin/env bash
source ./sh_scripts/variables.sh

echo Creating service principal $GITHUB_TF_SP_NAME...
az ad sp create-for-rbac --name $GITHUB_TF_SP_NAME --role reader --scopes /subscriptions/$SUBSCRIPTION_ID/resourceGroups/$TF_RESOURCE_GROUP_NAME
APP_ID=$(az ad sp list --display-name $GITHUB_TF_SP_NAME --query "[].{spID:appId}" --output tsv);
az role assignment create --assignee-object-id  $APP_ID --role contributor --subscription $SUBSCRIPTION_ID --assignee-principal-type ServicePrincipal --scope /subscriptions/$SUBSCRIPTION_ID/resourcegroups/$BUILD_RESOURCE_GROUP_NAME_RESOURCES
az keyvault set-policy --name $TF_KEYVAULT_NAME --spn $APP_ID --secret-permissions get

az ad app federated-credential create --id  $APP_ID --parameters ./configs/github_oicd_credential.json

echo Setting Github secrets...
echo AZURE_CLIENT_ID=$APP_ID
echo AZURE_SUBSCRIPTION_ID=$SUBSCRIPTION_ID
echo AZURE_TENANT_ID=$TENANT_ID
gh auth login
gh secret set AZURE_CLIENT_ID --body ${APP_ID} --repos $GIT_ROOT/$TF_REPO;
gh secret set AZURE_TENANT_ID --body ${TENANT_ID} --repos $GIT_ROOT/$TF_REPO;
gh secret set AZURE_SUBSCRIPTION_ID --body ${SUBSCRIPTION_ID} --repos $GIT_ROOT/$TF_REPO;
