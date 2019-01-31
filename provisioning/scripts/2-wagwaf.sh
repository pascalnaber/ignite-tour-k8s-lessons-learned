set -e -x

# WAG
az network application-gateway create \
  --name $WAG_NAME \
  --location $LOCATION \
  --resource-group $RESOURCEGROUP_NETWORK \
  --vnet-name $VNET_NAME \
  --subnet aks-wag \
  --public-ip-address $IPADDRESS_NAME \
  --sku $WAF_SKU \
  --capacity 2 \
  --servers $AKS_PRIVATE_IPADDRESS

# WAF
  az network application-gateway waf-config set \
  --enabled true \
  --gateway-name $WAG_NAME \
  --resource-group $RESOURCEGROUP_NETWORK \
  --firewall-mode Detection \
  --rule-set-version 3.0

