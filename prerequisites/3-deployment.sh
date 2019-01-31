set -x -e

# Create SPN-Deploy (write access to container registry)
# NOT idempotent
set +e
SPN_DEPLOY_PASSWORD=$(az ad sp create-for-rbac --name $SPN_DEPLOY_NAME --role Contributor --query password --output tsv)
set -e
if [ $? -eq 0 ];
then    
    az keyvault secret set --vault-name $KEYVAULT_NAME --name spn-deploy-password --value $SPN_DEPLOY_PASSWORD    
fi

SPN_DEPLOY_ID=$(az ad sp show --id http://$SPN_DEPLOY_NAME --query appId --output tsv)
az keyvault secret set --vault-name $KEYVAULT_NAME --name spn-deploy-id --value $SPN_DEPLOY_ID

RESOURCEGROUP_NETWORK_RESOURCEID=$(az group show -n $RESOURCEGROUP_NETWORK --query id -o tsv)
RESOURCEGROUP_DATA_RESOURCEID=$(az group show -n $RESOURCEGROUP_DATA --query id -o tsv)
RESOURCEGROUP_K8S_RESOURCEID=$(az group show -n $RESOURCEGROUP_K8S --query id -o tsv)
RESOURCEGROUP_KEYVAULT_RESOURCEID=$(az group show -n $RESOURCEGROUP_KEYVAULT --query id -o tsv)
RESOURCEGROUP_COMMON_RESOURCEID=$(az group show -n $RESOURCEGROUP_COMMON --query id -o tsv)

# NOT idempotent
set +e
az role assignment create --role Contributor --assignee $SPN_DEPLOY_ID --scope $RESOURCEGROUP_NETWORK_RESOURCEID
az role assignment create --role Contributor --assignee $SPN_DEPLOY_ID --scope $RESOURCEGROUP_DATA_RESOURCEID
az role assignment create --role Contributor --assignee $SPN_DEPLOY_ID --scope $RESOURCEGROUP_K8S_RESOURCEID
az role assignment create --role Contributor --assignee $SPN_DEPLOY_ID --scope $RESOURCEGROUP_KEYVAULT_RESOURCEID
az role assignment create --role Contributor --assignee $SPN_DEPLOY_ID --scope $RESOURCEGROUP_COMMON_RESOURCEID
set -e