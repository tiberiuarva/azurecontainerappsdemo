# Demo 1

## Title: Communication between microservices in Azure Containers Apps

Demo 1 showcases the communication between two microservices in Azure Container Apps. The solution is composed of 2 Applications. The frontend application represents the User Interface and the backend application is the backend API of the solution. The frontend makes a direct service call to the backend API.

## Components

- Frontend UI
    - Languages: Javascript
    - Source code: https://github.com/Azure-Samples/containerapps-albumapi-javascript
- Backend API
    - Languages: C#
    - Source code: https://github.com/azure-samples/containerapps-albumapi-csharp

## Deployment

The infrastrcture and apps are deployed using **Azure CLI** 

Tutorial: https://learn.microsoft.com/en-us/azure/container-apps/communicate-between-microservices