RESOURCEGROUP_AKS=matrix-dev-k8s
IDENTITY_AKSKEYVAULT_NAME=identity-kv-aks-dev
SUBSCRIPTION_ID=186d83fa-fddb-4637-a762-918a4cc06ee0
RESOURCEGROUP_KEYVAULT=matrix-dev-keyvault
KEYVAULT_NAME=matrix-secrets-dev

### https://github.com/Azure/kubernetes-keyvault-flexvol

### Install the KeyVault Flexvolume
kubectl create -f 1-kv-flexvol-installer.yaml

###  Use the KeyVault FlexVolume

## 1 Deploy Pod identity components
kubectl apply -f 2-azure-aad-identity-infra.yaml

## 2 Create Azure User Identity
az identity create -g $RESOURCEGROUP_AKS -n $IDENTITY_AKSKEYVAULT_NAME
IDENTITY_PRINCIPALID=$(az identity show -g $RESOURCEGROUP_AKS -n $IDENTITY_AKSKEYVAULT_NAME --query principalId -o tsv)
IDENTITY_CLIENTID=$(az identity show -g $RESOURCEGROUP_AKS -n $IDENTITY_AKSKEYVAULT_NAME --query clientId -o tsv)

# Assign Reader Role to new Identity for your keyvault
az role assignment create --role Reader --assignee $IDENTITY_PRINCIPALID --scope /subscriptions/$SUBSCRIPTION_ID/resourcegroups/$RESOURCEGROUP_KEYVAULT/providers/Microsoft.KeyVault/vaults/$KEYVAULT_NAME

#EXTRA???
az role assignment create --role Reader --assignee $IDENTITY_PRINCIPALID --scope /subscriptions/$SUBSCRIPTION_ID/resourcegroups/$RESOURCEGROUP_KEYVAULT
az role assignment create --role "Managed Identity Operator" --assignee $IDENTITY_PRINCIPALID --scope <azure_identitys_id>
az role assignment create --role "Managed Identity Operator" --assignee 337d2ca9-6271-464f-ac82-1f803db74f2e --scope /subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RESOURCEGROUP_AKS/providers/Microsoft.ManagedIdentity/userAssignedIdentities/$IDENTITY_AKSKEYVAULT_NAME

# set policy to access keys, secrets and certs in your keyvault
az keyvault set-policy -n $KEYVAULT_NAME --key-permissions get --spn $IDENTITY_CLIENTID
az keyvault set-policy -n $KEYVAULT_NAME --secret-permissions get --spn $IDENTITY_CLIENTID
az keyvault set-policy -n $KEYVAULT_NAME --certificate-permissions get --spn $IDENTITY_CLIENTID

kubectl apply -f 3-aadpodidentity.yaml
kubectl apply -f 4-aadpodidentitybinding.yaml
kubectl apply -f deployment.yaml
kubectl apply -f _secretvisualiser.yaml
kubectl apply -f ./uni/deploymentuni.yaml
kubectl exec -it nginx-flex-kv-podid cat /kvmnt/Secret2
clear
kubectl exec -it nginx-flex-kv-podid cat /kvmnt/Secret1
kubectl exec -it nginx-flex-kv-podid 'ls' /kvmnt/
kubectl exec -it nginx-flex-kv-podid sh
k describe pod nginx-flex-kv-podid 
k delete pod nginx-flex-kv-podid
az keyvault secret set -n Secret1 --value TopSecret --vault-name $KEYVAULT_NAME
# az keyvault secret set -n Secret2 --value YouDontHaveToKnow --vault-name $KEYVAULT_NAME
kubectl exec -it nginx-flex-kv-podid cat /kvmnt/postgresdb
kubectl exec -it nginx-flex-kv-podid cat /kvmnt/blobstoragesecret
# helm upgrade keyvaulttest --install ./keyvaultaadpodidentity --debug --dry-run --set 

# The Pod "nginx-flex-kv-podid" is invalid: spec: Forbidden: pod updates may not change fields other than `spec.containers[*].image`, `spec.initContainers[*].image`, `spec.activeDeadlineSeconds` or `spec.tolerations` (only additions to existing tolerations)