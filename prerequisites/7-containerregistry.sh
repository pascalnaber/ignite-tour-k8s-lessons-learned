set -x -e

az acr create --name $REGISTRY_NAME --resource-group $RESOURCEGROUP_COMMON --sku Basic --admin-enabled false
REGISTRY_RESOURCEID=$(az acr show -g $RESOURCEGROUP_COMMON -n $REGISTRY_NAME --query id --output tsv)

# Create SPN-Registry (read access to container registry)
set +e
SPN_REGISTRY_PASSWORD=$(az ad sp create-for-rbac --name $SPN_REGISTRY_NAME --role Contributor --query password --output tsv)
set -e
if [ $? -eq 0 ];
then    
    az keyvault secret set --vault-name $KEYVAULT_NAME --name spn-registry-password --value $SPN_REGISTRY_PASSWORD  
fi

SPN_REGISTRY_ID=$(az ad sp show --id http://$SPN_REGISTRY_NAME --query appId --output tsv)
az keyvault secret set --vault-name $KEYVAULT_NAME --name spn-registry-id --value $SPN_REGISTRY_ID

set +e
az role assignment create --assignee http://$SPN_REGISTRY_NAME --scope $REGISTRY_RESOURCEID --role acrpull
az role assignment create --assignee http://$SPN_DEPLOY_NAME --scope $REGISTRY_RESOURCEID --role acrpush
set -e