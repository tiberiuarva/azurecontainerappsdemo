# Sign in to Azure from the CLI
az login

# Ensure you're running the latest version of the CLI 
az upgrade

# Install or update the Azure Container Apps extension for the CLI
az extension add --name containerapp --upgrade

# Register the Microsoft.App and Microsoft.OperationalInsights namespaces 
az provider register --namespace Microsoft.App
az provider register --namespace Microsoft.OperationalInsights
