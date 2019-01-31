set -x -e

KEYVAULT_ID=$(az keyvault show -n $KEYVAULT_NAME -g $RESOURCEGROUP_KEYVAULT --query id -o tsv)
SPN_DEPLOY_ID=$(az ad sp show --id http://$SPN_DEPLOY_NAME --query appId --output tsv)

# Assign Reader Role to the service principal for deployment
set +e
az role assignment create --role Reader --assignee $SPN_DEPLOY_ID --scope $KEYVAULT_ID
set -e

# Update the security policy of the Keyvault so the SPN-Deploy can read keys/secrets/certificates (list for Azure DevOps)
az keyvault set-policy -n $KEYVAULT_NAME --secret-permissions get list --spn $SPN_DEPLOY_ID
az keyvault set-policy -n $KEYVAULT_NAME --certificate-permissions get import --spn $SPN_DEPLOY_ID



