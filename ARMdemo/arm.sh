#!/bin/bash

export location=northeurope
export username=azureuser
export projectName=AppServer

echo "Enter the Resource Group name:" && read resourceGroupName \
&& echo "Enter the SSH public key:" && read key \
&& az group create --name $resourceGroupName --location "$location" \
&& az deployment group create --resource-group $resourceGroupName \
--template-file /c/Users/Oscar/Documents/Github/ServerArm/ARMdemo/deploy.json \
--parameters projectName=$projectName adminUsername=$username adminPublicKey="$key" customData=@install_dotnet_runtime.sh customData2=@install_nginx_block.sh \
&& az vm show --resource-group $resourceGroupName --name "$projectName" --show-details --query publicIps --output tsv