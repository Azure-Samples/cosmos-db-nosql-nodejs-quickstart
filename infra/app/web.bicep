metadata description = 'Create web application host resources.'

param appName string
param serviceTag string
param location string = resourceGroup().location
param tags object = {}

@description('Name of the environment where the application will be hosted.')
param envName string

@description('Endpoint for Azure Cosmos DB for NoSQL account.')
param databaseAccountEndpoint string

type managedIdentity = {
  resourceId: string
  clientId: string
}

@description('Unique identifier for user-assigned managed identity.')
param userAssignedManagedIdentity managedIdentity

module containerAppsApp '../core/host/container-apps/app.bicep' = {
  name: 'container-apps-app-${appName}'
  params: {
    name: appName
    parentEnvironmentName: envName
    location: location
    tags: union(tags, {
      'azd-service-name': serviceTag
    })
    secrets: [
      {
        name: 'azure-cosmos-db-nosql-endpoint' // Create a uniquely-named secret
        value: databaseAccountEndpoint // NoSQL database account endpoint
      }
      {
        name: 'azure-managed-identity-client-id' // Create a uniquely-named secret
        value: userAssignedManagedIdentity.clientId // Client ID of user-assigned managed identity
      }
    ]
    environmentVariables: [
      {
        name: 'COSMOS_DB_ENDPOINT' // Name of the environment variable referenced in the application
        secretRef: 'azure-cosmos-db-nosql-endpoint' // Reference to secret
      }
      {
        name: 'AZURE_CLIENT_ID' // Name of the environment variable referenced in the application
        secretRef: 'azure-managed-identity-client-id' // Reference to secret
      }
    ]
    targetPort: 3000
    enableSystemAssignedManagedIdentity: false
    userAssignedManagedIdentityIds: [
      userAssignedManagedIdentity.resourceId
    ]
  }
}

output name string = containerAppsApp.outputs.name
output endpoint string = containerAppsApp.outputs.endpoint
