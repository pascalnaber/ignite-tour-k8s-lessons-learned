set -x -e

# Create Azure User Identity (Keyvault access for AKS)
az identity create -g $RESOURCEGROUP_K8S -n $IDENTITY_AKSKEYVAULT_NAME
IDENTITY_PRINCIPALID=$(az identity show -g $RESOURCEGROUP_K8S -n $IDENTITY_AKSKEYVAULT_NAME --query principalId -o tsv)
IDENTITY_CLIENTID=$(az identity show -g $RESOURCEGROUP_K8S -n $IDENTITY_AKSKEYVAULT_NAME --query clientId -o tsv)

# set policy to access keys, secrets and certs in your keyvault for Managed Identity
az keyvault set-policy -n $KEYVAULT_NAME --key-permissions get --spn $IDENTITY_CLIENTID
az keyvault set-policy -n $KEYVAULT_NAME --secret-permissions get --spn $IDENTITY_CLIENTID
az keyvault set-policy -n $KEYVAULT_NAME --certificate-permissions get --spn $IDENTITY_CLIENTID

KEYVAULT_ID=$(az keyvault show -n $KEYVAULT_NAME -g $RESOURCEGROUP_KEYVAULT --query id -o tsv)

# Assign Reader Role to Managed Identity for keyvault
set +e
az role assignment create --role Reader --assignee $IDENTITY_PRINCIPALID --scope $KEYVAULT_ID
set -e

