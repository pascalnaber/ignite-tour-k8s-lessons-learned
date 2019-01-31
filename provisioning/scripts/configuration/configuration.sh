set -e

az login --service-principal -u $SPN_ID -p $SPN_PASSWORD --tenant $TENANTID

az aks get-credentials --resource-group $RESOURCEGROUP_K8S --name $AKS_NAME

# make the dashboard access work
#kubectl create clusterrolebinding kubernetes-dashboard -n kube-system --clusterrole=cluster-admin --serviceaccount=kube-system:kubernetes-dashboard
kubectl apply -f dashboard.yaml
#kubectl delete ClusterRoleBinding kubernetes-dashboard
#kubectl apply -f dashboard.readonly.yaml

# helm service account and other needed resources
kubectl apply -f helm.yaml

# install helm locally & on the k8s cluster (tiller)
helm init --service-account tiller-serviceaccount --upgrade --force-upgrade

# latest charts
helm repo update

# install ingress
helm upgrade nginxingress --install stable/nginx-ingress --namespace kube-system -f internalingress.yaml 

# install keyvaultaadpodidentity
IDENTITY_CLIENTID=$(az identity show -g $RESOURCEGROUP_K8S -n $IDENTITY_AKSKEYVAULT_NAME --query clientId -o tsv)
IDENTITY_ID=$(az identity show -g $RESOURCEGROUP_K8S -n $IDENTITY_AKSKEYVAULT_NAME --query id -o tsv)

helm upgrade keyvaultaadpodidentity --debug --install ./aad-pod-identity --force \
   --set azureIdentityBinding.selector=matrix,azureIdentity.clientID=$IDENTITY_CLIENTID,azureIdentity.resourceID=$IDENTITY_ID

helm upgrade kured --install stable/kured --namespace kured