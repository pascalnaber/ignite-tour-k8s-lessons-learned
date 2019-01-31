kubectl apply -f podinfo-deployment.yaml

KEYVAULT_NAME=matrix-secrets-dev

kubectl create secret docker-registry matriximages --docker-server=matriximages.azurecr.io --namespace app-podinfo-master \
  --docker-username=$(az keyvault secret show --name spn-registry-id --vault-name $KEYVAULT_NAME --query value -o tsv) \
  --docker-password=$(az keyvault secret show --name spn-registry-password --vault-name $KEYVAULT_NAME --query value -o tsv) \
  --docker-email=pnaber@xpirit.com

