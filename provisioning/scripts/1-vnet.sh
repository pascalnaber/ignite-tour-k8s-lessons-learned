# set -e
set -x

# # Create VNET
az network vnet create -g $RESOURCEGROUP_NETWORK -n $VNET_NAME --address-prefix 10.0.0.0/8 -l $LOCATION

# # Create Subnets
az network vnet subnet create -g $RESOURCEGROUP_NETWORK --vnet-name $VNET_NAME -n aks-subnet --address-prefix 10.240.0.0/16 
az network vnet subnet create -g $RESOURCEGROUP_NETWORK --vnet-name $VNET_NAME -n aks-wag --address-prefix 10.0.1.0/24 

# Public Dynamic IP address for the WAG/WAF (WAF_v2 can have a static IP) DNS should start with a letter
az network public-ip create -g $RESOURCEGROUP_NETWORK -n $IPADDRESS_NAME --allocation-method Dynamic --sku Basic --dns-name a$(cat /proc/sys/kernel/random/uuid)

