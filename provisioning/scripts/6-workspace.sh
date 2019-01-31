set -e -x

az group deployment create --resource-group $RESOURCEGROUP_K8S \
   --template-file $WORKSPACE_ARMTEMPLATE_PATH \
   --parameters workspaceName=$WORKSPACE_NAME serviceTier=PerNode location=$LOCATION --verbose
