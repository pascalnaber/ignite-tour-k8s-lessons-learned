set -x -e

# Create SPN-AKS
set +e
SPN_AKS_PASSWORD=$(az ad sp create-for-rbac --name $SPN_AKS_NAME --role Contributor --query password --output tsv )
set -e
if [ $? -eq 0 ];
then    
    az keyvault secret set --vault-name $KEYVAULT_NAME --name spn-aks-password --value $SPN_AKS_PASSWORD
fi

SPN_AKS_ID=$(az ad sp show --id http://$SPN_AKS_NAME --query appId --output tsv)
az keyvault secret set --vault-name $KEYVAULT_NAME --name spn-aks-id --value $SPN_AKS_ID

RESOURCEGROUP_K8S_RESOURCEID=$(az group show -n $RESOURCEGROUP_K8S --query id -o tsv)
set +e
az role assignment create --role Contributor --assignee $SPN_AKS_ID --scope $RESOURCEGROUP_K8S_RESOURCEID

# Give Deployment service principal rights to VNET for AKS
az role assignment create --assignee $SPN_DEPLOY_ID --role "Network Contributor"

az keyvault secret show --vault-name $KEYVAULT_NAME --name ssh-publickeys > /dev/null 
set -e 
if [ $? -eq 3 ];
then  
    # Generate SSH Key for AKS With generated password. If key already exists, it will be reused.
    SSH_PASSWORD=$(openssl rand -base64 32)
    ssh-keygen -C "matrix" -f ~/.ssh/id_rsa -P $SSH_PASSWORD -q 0>&-
    echo $?
    # Add SSH keys to Keyvault
    az keyvault secret set --vault-name $KEYVAULT_NAME --name ssh-publickey -f ~/.ssh/id_rsa.pub 
    az keyvault secret set --vault-name $KEYVAULT_NAME --name ssh-privatekey -f ~/.ssh/id_rsa
    az keyvault secret set --vault-name $KEYVAULT_NAME --name ssh-password --value "$SSH_PASSWORD"
fi


