az login

RESOURCE_GROUP="my-container-apps-demo"
LOCATION="westeurope"
CONTAINERAPPS_ENVIRONMENT="my-ca-environment"

az group create \
  --name $RESOURCE_GROUP \
  --location $LOCATION


az containerapp env create \
  --name $CONTAINERAPPS_ENVIRONMENT \
  --resource-group $RESOURCE_GROUP \
  --location $LOCATION


az containerapp create \
  --name my-container-app \
  --resource-group $RESOURCE_GROUP \
  --environment $CONTAINERAPPS_ENVIRONMENT \
  --image mcr.microsoft.com/azuredocs/containerapps-helloworld:latest \
  --target-port 80 \
  --ingress 'external' \
  --query properties.configuration.ingress.fqdn