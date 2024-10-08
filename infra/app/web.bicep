metadata description = 'Create web application host resources.'

param appName string
param serviceTag string
param location string = resourceGroup().location
param tags object = {}

@description('Name of the environment where the application will be hosted.')
param envName string

@description('Endpoint for Azure Cosmos DB for NoSQL account.')
param databaseAccountEndpoint string

module containerAppsApp '../core/host/container-apps/app.bicep' = {
  name: 'container-apps-app-${appName}'
  params: {
    name: appName
    parentEnvironmentName: envName
    location: location
    tags: union(tags, {
      'azd-service-name': serviceTag
    })
    transport: 'http'
    secrets: [
      {
        name: 'azure-cosmos-db-nosql-endpoint' // Create a uniquely-named secret
        value: databaseAccountEndpoint // NoSQL database account endpoint
      }
    ]
    environmentVariables: [
      {
        name: 'AZURE_COSMOS_DB_NOSQL_ENDPOINT' // Name of the environment variable referenced in the application
        secretRef: 'azure-cosmos-db-nosql-endpoint' // Reference to secret
      }
    ]
    targetPort: 3000
    enableSystemAssignedManagedIdentity: true
  }
}

output name string = containerAppsApp.outputs.name
output endpoint string = containerAppsApp.outputs.endpoint
output systemAssignedManagedIdentityPrincipalId string =  containerAppsApp.outputs.systemAssignedManagedIdentityPrincipalId
