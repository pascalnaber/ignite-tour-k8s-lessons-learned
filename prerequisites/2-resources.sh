set -x -e

az keyvault create --name $KEYVAULT_NAME --resource-group $RESOURCEGROUP_KEYVAULT --enabled-for-template-deployment --enabled-for-deployment