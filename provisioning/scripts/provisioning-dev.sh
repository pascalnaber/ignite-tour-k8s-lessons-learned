#!/bin/bash

LOCATION=westeurope
RESOURCEGROUP_NETWORK=matrix-dev-network
RESOURCEGROUP_K8S=matrix-dev-k8s
RESOURCEGROUP_KEYVAULT=matrix-dev-keyvault
RESOURCEGROUP_COMMON=matrix-common
DOMAIN_NAME=dev-ignitetour.cf
VNET_NAME=matrix-aks-vnet
WORKSPACE_NAME=matrix-workspace-dev
WORKSPACE_ARMTEMPLATE_PATH="../arm/resources/Microsoft.OperationalInsights/deploy.json"
AKS_NAME=matrix-aks-dev
AKS_NODE_COUNT=2
AKS_VM_SIZE=Standard_DS2_v2
AKS_PRIVATE_IPADDRESS="10.240.2.42"
IPADDRESS_NAME=matrix-wag-dyn-ip
TRAFFICMANAGER_NAME=matrix-dev
WAG_NAME=matrix-wag-dev
WAF_SKU=WAF_Medium
KEYVAULT_NAME=matrix-secrets-dev
WAG_PROBE_URI=health.dev-ignitetour.cf

# CERTIFICATE_NAME=dev-ohub2-com
# WAG_CERT_NAME=dev-ohub2-com

clear
. provisioning.sh

