az aks get-credentials --resource-group matrix-dev-k8s --name matrix-aks-dev
SPN_ID=3229176e-eb51-41bd-b3fa-a99f9d017333 #deployment

IDENTITY_CLIENTID=$(az identity show -g $RESOURCEGROUP_K8S -n $IDENTITY_AKSKEYVAULT_NAME --query clientId -o tsv)
IDENTITY_ID=$(az identity show -g $RESOURCEGROUP_K8S -n $IDENTITY_AKSKEYVAULT_NAME --query id -o tsv)

helm upgrade keyvaultaadpodidentity --debug --install ./aad-pod-identity --force  --set azureIdentityBinding.selector=matrix,azureIdentity.clientID=$IDENTITY_CLIENTID,azureIdentity.resourceID=$IDENTITY_ID 
--set createCustomResource=true
k get customresourcedefinition
k delete customresourcedefinition azureassignedidentities.aadpodidentity.k8s.io

k delete customresourcedefinition azureidentities.aadpodidentity.k8s.io
k delete customresourcedefinition azureidentitybindings.aadpodidentity.k8s.io
helm list
helm upgrade -h

k get clusterrole view
k describe clusterrole view
k get clusterrolebinding
k delete clusterrolebinding kubernetes-dashboard
kubectl create clusterrolebinding kubernetes-dashboard -n kube-system --clusterrole=cluster-admin --serviceaccount=kube-system:kubernetes-dashboard