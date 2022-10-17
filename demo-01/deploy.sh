# Variable declaration
RESOURCE_GROUP="azure-container-apps-demo"
LOCATION="westeurope"
ENVIRONMENT="containerapps-env-demo"
API_NAME="album-api"
FRONTEND_NAME="album-ui"
GITHUB_USERNAME="tiberiuarva"
ACR_NAME="acaalbumsacr01"
LA_WORKSPACE_NAME="acaalbumslaw01"

# Create Resource Group
az group create --name $RESOURCE_GROUP --location "$LOCATION"

# Create Azure Container Registry
az acr create --resource-group $RESOURCE_GROUP --name $ACR_NAME --sku Basic --admin-enabled true

# Create Log Analytics Workspace
az monitor log-analytics workspace create \
    --resource-group $RESOURCE_GROUP \
    --workspace-name $LA_WORKSPACE_NAME

# Save Log Analytics Workspace Key and Id in variables
LA_WORKSPACE_ID=$(az monitor log-analytics workspace show --resource-group $RESOURCE_GROUP --workspace-name $LA_WORKSPACE_NAME --query "customerId" -o tsv)
LA_WORKSPACE_KEY=$(az monitor log-analytics workspace get-shared-keys --resource-group $RESOURCE_GROUP --workspace-name $LA_WORKSPACE_NAME --query "primarySharedKey" -o tsv)

# Create the Container Apps environment 
az containerapp env create \
    --name $ENVIRONMENT \
    --resource-group $RESOURCE_GROUP \
    --logs-workspace-id $LA_WORKSPACE_ID \
    --logs-workspace-key $LA_WORKSPACE_KEY \
    --location $LOCATION

# Clone Album App backend API repository and change directory to 'src/'
cd /home/tiberiu
git clone https://github.com/$GITHUB_USERNAME/containerapps-albumapi-csharp.git backend-api
cd backend-api/src
git pull origin

# Build the Album App backend API container image with ACR
az acr build \
    --resource-group $RESOURCE_GROUP \
    --registry $ACR_NAME \
    --image $API_NAME .

# Deploy the Album App backend API in an Azure Container App using the custom image created
az containerapp create \
    --name $API_NAME \
    --resource-group $RESOURCE_GROUP \
    --environment $ENVIRONMENT \
    --image $ACR_NAME.azurecr.io/$API_NAME \
    --target-port 3500 \
    --ingress 'external' \
    --registry-server $ACR_NAME.azurecr.io \
    --query configuration.ingress.fqdn

# Clone the code of the Album App frontend UI
cd /home/tiberiu
git clone https://github.com/$GITHUB_USERNAME/containerapps-albumui.git frontend-ui
cd frontend-ui/src
git pull origin

# Build the Album App frontend UI container image with ACR
az acr build --registry $ACR_NAME --image albumapp-ui .

# Query the API endpoint address of the Album App backend API and save it in a variable
API_BASE_URL=$(az containerapp show --resource-group $RESOURCE_GROUP --name $API_NAME --query properties.configuration.ingress.fqdn -o tsv)

# Deploy the Album App frontend UI in an Azure Container App using the custom image created
az containerapp create \
  --name $FRONTEND_NAME \
  --resource-group $RESOURCE_GROUP \
  --environment $ENVIRONMENT \
  --image $ACR_NAME.azurecr.io/albumapp-ui  \
  --target-port 3000 \
  --env-vars API_BASE_URL=https://$API_BASE_URL \
  --ingress 'external' \
  --registry-server $ACR_NAME.azurecr.io \
  --query configuration.ingress.fqdn

# Cleanup resources
az group delete --name $RESOURCE_GROUP --yes