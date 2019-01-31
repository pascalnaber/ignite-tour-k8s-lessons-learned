IDENTITY_CLIENTID=$(az identity show -g $RESOURCEGROUP_AKS -n $IDENTITY_AKSKEYVAULT_NAME --query clientId -o tsv)
IDENTITY_ID=$(az identity show -g $RESOURCEGROUP_AKS -n $IDENTITY_AKSKEYVAULT_NAME --query id -o tsv)

helm upgrade keyvaultaadpodidentity --install ./aad-pod-identity --force \
   --set azureIdentityBinding.selector=matrix,azureIdentity.clientID=$IDENTITY_CLIENTID,azureIdentity.resourceID=$IDENTITY_ID

# --debug --dry-run \
echo "configure your deployment with the volume and add label aadpodidbinding with value $DEPLOYMENT_LABEL" 