KEYVAULT_NAME=matrix-secrets-dev

helm upgrade secretviewer-master --namespace master-app-keyvault --install secretviewer --force --set image.tag=523,ingress.hostName=dev-ignitetour.cf,imageCredentials.username=$(az keyvault secret show --name spn-registry-id --vault-name $KEYVAULT_NAME --query value -o tsv),imageCredentials.password=$(az keyvault secret show --name spn-registry-password --vault-name $KEYVAULT_NAME --query value -o tsv) -f config-dev.yaml
# --debug --dry-run
#helm.exe upgrade --namespace master-app-podinfo --install --force --values D:\a\r1\a\_app-podinfo-CI\drop\config-dev.yaml --set image.tag=523,ingress.hostName=dev-ignitetour.cf --wait master-app-podinfo D:\a\r1\a\_app-podinfo-CI\drop\podinfo