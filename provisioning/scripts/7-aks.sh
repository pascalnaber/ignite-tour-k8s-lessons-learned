set -e -x

# Get ResourceId from aks-subnet
AKSSUBNETID=$(az network vnet subnet show -g $RESOURCEGROUP_NETWORK -n aks-subnet --vnet-name $VNET_NAME --query id --output tsv)
echo SubnetID: $AKSSUBNETID

az group deployment create --resource-group $RESOURCEGROUP_K8S \
   --template-file $WORKSPACE_ARMTEMPLATE_PATH \
   --parameters workspaceName=$WORKSPACE_NAME serviceTier=PerNode location=$LOCATION --verbose

WORKSPACE_RESOURCEID=$(az resource show -g $RESOURCEGROUP_K8S -n $WORKSPACE_NAME --resource-type "Microsoft.OperationalInsights/workspaces" --query 'id' -o tsv)
echo workspace_resourceid: $WORKSPACE_RESOURCEID

# # Create AKS
az aks create -g $RESOURCEGROUP_K8S -n $AKS_NAME \
  --kubernetes-version 1.11.5 \
  --node-count $AKS_NODE_COUNT \
  --node-vm-size $AKS_VM_SIZE \
  --max-pods 110 \
  --ssh-key-value "$(az keyvault secret show --name ssh-publickey --vault-name $KEYVAULT_NAME --query value -o tsv)" \
  --service-principal $(az keyvault secret show --name spn-aks-id --vault-name $KEYVAULT_NAME --query value -o tsv) \
  --client-secret "$(az keyvault secret show --name spn-aks-password --vault-name $KEYVAULT_NAME --query value -o tsv)" \
  --network-plugin azure \
  --vnet-subnet-id $AKSSUBNETID \
  --docker-bridge-address 172.17.0.1/16 --dns-service-ip 10.2.0.10 --service-cidr 10.2.0.0/24 \
  --enable-addons monitoring --workspace-resource-id $WORKSPACE_RESOURCEID

