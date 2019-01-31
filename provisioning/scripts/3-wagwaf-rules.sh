set -e -x

Configure WAG to route all traffic to K8S
echo "create probe"
az network application-gateway probe create -g $RESOURCEGROUP_NETWORK --gateway-name $WAG_NAME \
                            -n matrix-probe --protocol http --host $WAG_PROBE_URI --path /


echo "create httpsetting"
az network application-gateway frontend-port update -g $RESOURCEGROUP_NETWORK --gateway-name $WAG_NAME \
                            -n appGatewayFrontendPort --port 88

az network application-gateway frontend-port create -g $RESOURCEGROUP_NETWORK --gateway-name $WAG_NAME \
                            -n frontend-http-port --port 80

az network application-gateway http-settings create -g $RESOURCEGROUP_NETWORK --gateway-name $WAG_NAME \
                          -n matrix-http-setting --port 80 --protocol Http --cookie-based-affinity Disabled --timeout 30 \
                          --probe matrix-probe

echo "create listener"
az network application-gateway http-listener create -g $RESOURCEGROUP_NETWORK --gateway-name $WAG_NAME \
                               -n matrix-http-listener --frontend-port frontend-http-port  --frontend-ip appGatewayFrontendIP                                                      

echo "create rule"
az network application-gateway rule create -g $RESOURCEGROUP_NETWORK --gateway-name $WAG_NAME \
                            -n matrix-rule --http-listener matrix-http-listener --rule-type Basic \
                            --address-pool appGatewayBackendPool --http-settings matrix-http-setting

# Clean up the originaly created configuration
az network application-gateway rule delete -g $RESOURCEGROUP_NETWORK --gateway-name $WAG_NAME -n rule1
az network application-gateway http-settings delete -g $RESOURCEGROUP_NETWORK --gateway-name $WAG_NAME -n appGatewayBackendHttpSettings
az network application-gateway http-listener delete -g $RESOURCEGROUP_NETWORK --gateway-name $WAG_NAME -n appGatewayHttpListener