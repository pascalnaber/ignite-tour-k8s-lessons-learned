#Configure WAG to route all traffic to K8S
echo "create probe"
az network application-gateway probe create -g $RESOURCEGROUP_VNET_NAME --gateway-name $WAG_NAME \
                            -n ohub2-probe --protocol http --host $WAG_PROBE_URI --path /
echo "create httpsetting"
az network application-gateway http-settings create -g $RESOURCEGROUP_VNET_NAME --gateway-name $WAG_NAME \
                          -n ohub2-http-setting --port 80 --protocol Http --cookie-based-affinity Disabled --timeout 30 \
                          --probe ohub2-probe
echo "create frontendport"
az network application-gateway frontend-port create -g $RESOURCEGROUP_VNET_NAME --gateway-name $WAG_NAME \
                            -n frontend-https-port --port 443

echo "create sslcert"
az network application-gateway ssl-cert create -g $RESOURCEGROUP_VNET_NAME --gateway-name $WAG_NAME \
                            -n $WAG_CERT_NAME --cert-file $CERTIFICATE_PATH --cert-password $WAG_CERT_PASSWORD
echo "create listener"
az network application-gateway http-listener create -g $RESOURCEGROUP_VNET_NAME --gateway-name $WAG_NAME \
                            --frontend-port frontend-https-port -n ohub2-https-listener --frontend-ip appGatewayFrontendIP \
                            --ssl-cert $WAG_CERT_NAME                            

echo "create rule"
az network application-gateway rule create -g $RESOURCEGROUP_VNET_NAME --gateway-name $WAG_NAME \
                            -n ohub2-rule --http-listener ohub2-https-listener --rule-type Basic \
                            --address-pool appGatewayBackendPool --http-settings ohub2-http-setting