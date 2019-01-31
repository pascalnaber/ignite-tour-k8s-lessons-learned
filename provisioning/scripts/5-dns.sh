set -e -x

# Create DNS zone
az network dns zone create -g $RESOURCEGROUP_NETWORK -n $DOMAIN_NAME 

# Get resourceId of TrafficManager
TRAFFICMANAGER_RESOURCEID=$(az resource show -g $RESOURCEGROUP_NETWORK -n $TRAFFICMANAGER_NAME --resource-type "Microsoft.Network/trafficManagerProfiles" --query id --output tsv)
echo tmresourceid: $TRAFFICMANAGER_RESOURCEID

# # Add TrafficManager to DNS Zone
# echo domain: $DOMAIN_NAME
az network dns record-set cname create -g $RESOURCEGROUP_NETWORK -z $DOMAIN_NAME -n '*' --target-resource $TRAFFICMANAGER_RESOURCEID
