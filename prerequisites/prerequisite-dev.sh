LOCATION=westeurope
RESOURCEGROUP_NETWORK=matrix-dev-network
RESOURCEGROUP_DATA=matrix-dev-data
RESOURCEGROUP_K8S=matrix-dev-k8s
RESOURCEGROUP_KEYVAULT=matrix-dev-keyvault
RESOURCEGROUP_COMMON=matrix-common

SPN_REGISTRY_NAME=spn-matrix-registry
SPN_DEPLOY_NAME=spn-matrix-dev-deployment
SPN_AKS_NAME=spn-matrix-dev-k8s

KEYVAULT_NAME=matrix-secrets-dev
REGISTRY_NAME=matriximages
IDENTITY_AKSKEYVAULT_NAME=identity-kv-aks-dev

. ./prerequisite.sh