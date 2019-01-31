az group create -l $LOCATION -n $RESOURCEGROUP_KEYVAULT

# Provision Keyvault
az keyvault create --name $KEYVAULT_NAME --resource-group $RESOURCEGROUP_KEYVAULT --enabled-for-template-deployment --enabled-for-deployment

# ## Create Azure Mangaged Identity
az identity create -g $RESOURCEGROUP_AKS -n $IDENTITY_AKSKEYVAULT_NAME

IDENTITY_CLIENTID=$(az identity show -g $RESOURCEGROUP_AKS -n $IDENTITY_AKSKEYVAULT_NAME --query clientId -o tsv)
IDENTITY_ID=$(az identity show -g $RESOURCEGROUP_AKS -n $IDENTITY_AKSKEYVAULT_NAME --query id -o tsv)

# Assign Reader Role to Managed Identity for keyvault
az role assignment create --role Reader --assignee $IDENTITY_PRINCIPALID --scope /subscriptions/$SUBSCRIPTION_ID/resourcegroups/$RESOURCEGROUP_KEYVAULT/providers/Microsoft.KeyVault/vaults/$KEYVAULT_NAME

# set policy to access keys, secrets and certs in your keyvault
az keyvault set-policy -n $KEYVAULT_NAME --key-permissions get --spn $IDENTITY_CLIENTID
az keyvault set-policy -n $KEYVAULT_NAME --secret-permissions get --spn $IDENTITY_CLIENTID
az keyvault set-policy -n $KEYVAULT_NAME --certificate-permissions get --spn $IDENTITY_CLIENTID

helm upgrade keyvaultaadpodidentity --install ./aad-pod-identity \
   --set azureIdentityBinding.selector=$DEPLOYMENT_LABEL,azureIdentity.clientID=$IDENTITY_CLIENTID,azureIdentity.resourceID=$IDENTITY_ID

# --debug --dry-run \
echo "configure your deployment with the volume and add label aadpodidbinding with value $DEPLOYMENT_LABEL" 