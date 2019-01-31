set -x -e

# Create Resourcegroups
az group create -l $LOCATION -n $RESOURCEGROUP_NETWORK
az group create -l $LOCATION -n $RESOURCEGROUP_DATA
az group create -l $LOCATION -n $RESOURCEGROUP_K8S
az group create -l $LOCATION -n $RESOURCEGROUP_KEYVAULT
az group create -l $LOCATION -n $RESOURCEGROUP_COMMON
