#!/usr/bin/env bash

#You'll need to log into Azure first 'sudo az acr login'
cd docker
sudo az acr login --name ftatarifftooldataloader
sudo docker build -t ftatarifftooldataloader.azurecr.io/fta-tariff-tool-dataloader .
sudo docker push ftatarifftooldataloader.azurecr.io/fta-tariff-tool-dataloader
sudo az container delete --resource-group fta-tariff-tool-dataloader --name ftatarifftooldataloader --yes
sudo az container create --resource-group fta-tariff-tool-dataloader --name ftatarifftooldataloader \
    --image ftatarifftooldataloader.azurecr.io/fta-tariff-tool-dataloader:latest --dns-name-label fta-tariff-tool-dataloader --ports 80 \
    --location eastus --registry-username ftatarifftooldataloader --registry-password $TARIFFTOOL_AZURE_CONTAINER_KEY \
    --environment-variables 'TARIFFTOOL_AZURE_STORAGE_ACCOUNT'=$TARIFFTOOL_AZURE_STORAGE_ACCOUNT \
    'TARIFFTOOL_AZURE_STORAGE_ACCOUNT_KEY'=$TARIFFTOOL_AZURE_STORAGE_ACCOUNT_KEY \
    'TARIFFTOOL_AZURE_STORAGE_CONTAINER'=$TARIFFTOOL_AZURE_STORAGE_CONTAINER \
    'TARIFFTOOL_AZURE_OAUTH_CLIENT_ID'=TARIFFTOOL_AZURE_OAUTH_CLIENT_ID \
    'TARIFFTOOL_AZURE_OAUTH_CLIENT_SECRET'=TARIFFTOOL_AZURE_OAUTH_CLIENT_SECRET \
    'TARIFFTOOL_AZURE_OAUTH_TENANT_ID'=TARIFFTOOL_AZURE_OAUTH_TENANT_ID \

#FYI: Registry credentials are autogenerated and can be procured from portal.azure.com

#to view logs
#az container logs --resource-group fta-tariff-tool-dataloader --name ftatarifftooldataloader
cd ..