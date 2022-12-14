# Variable declaration
$RESOURCE_GROUP="azure-container-apps-demo"
$LOCATION="westeurope"
$CONTAINERAPPS_ENVIRONMENT="containerapps-env-demo"
$STORAGE_ACCOUNT_CONTAINER="mycontainer"
$STORAGE_ACCOUNT="containerappsdemo02"

# Login to Azure Account
az login

# Create Resource Group
az group create `
  --name $RESOURCE_GROUP `
  --location $LOCATION

# Create an Azure Storage account
az storage account create `
  --name $STORAGE_ACCOUNT `
  --resource-group $RESOURCE_GROUP `
  --location "$LOCATION" `
  --sku Standard_RAGRS `
  --kind StorageV2

# Deploy the Bicep template
az deployment group create `
  --resource-group "$RESOURCE_GROUP" `
  --template-file ./demo-02/azuredeploy.bicep `
  --parameters `
      environment_name="$CONTAINERAPPS_ENVIRONMENT" `
      location="$LOCATION" `
      storage_account_name="$STORAGE_ACCOUNT" `
      storage_container_name="$STORAGE_ACCOUNT_CONTAINER"

az group delete --resource-group $RESOURCE_GROUP --yes