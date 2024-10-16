metadata description = 'Create web application resources.'

param workspaceName string
param envName string
param appName string
param jsServiceTag string
param tsServiceTag string
param location string = resourceGroup().location
param tags object = {}

@description('Endpoint for Azure Cosmos DB for Table account.')
param databaseAccountEndpoint string

@description('Client ID of the service principal to assign database and application roles.')
param appClientId string

@description('Resource ID of the service principal to assign database and application roles.')
param appResourceId string

module logAnalyticsWorkspace 'br/public:avm/res/operational-insights/workspace:0.7.0' = {
  name: 'log-analytics-workspace'
  params: {
    name: workspaceName
    location: location
    tags: tags
  }
}

module containerAppsEnvironment 'br/public:avm/res/app/managed-environment:0.8.0' = {
  name: 'container-apps-env'
  params: {
    name: envName
    location: location
    tags: tags
    logAnalyticsWorkspaceResourceId: logAnalyticsWorkspace.outputs.resourceId
    zoneRedundant: false
  }
}

module containerAppsJsApp 'br/public:avm/res/app/container-app:0.9.0' = {
  name: 'container-apps-app-js'
  params: {
    name: appName
    environmentResourceId: containerAppsEnvironment.outputs.resourceId
    location: location
    tags: union(tags, { 'azd-service-name': jsServiceTag })
    ingressTargetPort: 3000
    ingressExternal: true
    ingressTransport: 'auto'
    managedIdentities: {
      systemAssigned: false
      userAssignedResourceIds: [
        appResourceId
      ]
    }
    secrets: {
      secureList: [
        {
          name: 'azure-cosmos-db-nosql-endpoint'
          value: databaseAccountEndpoint
        }
        {
          name: 'user-assigned-managed-identity-client-id'
          value: appClientId
        }
      ]
    }
    containers: [
      {
        image: 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'
        name: 'web-front-end'
        resources: {
          cpu: '0.25'
          memory: '0.5Gi'
        }
        env: [
          {
            name: 'AZURE_COSMOS_DB_NOSQL_ENDPOINT'
            secretRef: 'azure-cosmos-db-nosql-endpoint'
          }
          {
            name: 'AZURE_CLIENT_ID'
            secretRef: 'user-assigned-managed-identity-client-id'
          }
        ]
      }
    ]
  }
}
module containerAppsTsApp 'br/public:avm/res/app/container-app:0.9.0' = {
  name: 'container-apps-app-ts'
  params: {
    name: appName
    environmentResourceId: containerAppsEnvironment.outputs.resourceId
    location: location
    tags: union(tags, { 'azd-service-name': tsServiceTag })
    ingressTargetPort: 3000
    ingressExternal: true
    ingressTransport: 'auto'
    managedIdentities: {
      systemAssigned: false
      userAssignedResourceIds: [
        appResourceId
      ]
    }
    secrets: {
      secureList: [
        {
          name: 'azure-cosmos-db-nosql-endpoint'
          value: databaseAccountEndpoint
        }
        {
          name: 'user-assigned-managed-identity-client-id'
          value: appClientId
        }
      ]
    }
    containers: [
      {
        image: 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'
        name: 'web-front-end'
        resources: {
          cpu: '0.25'
          memory: '0.5Gi'
        }
        env: [
          {
            name: 'AZURE_COSMOS_DB_NOSQL_ENDPOINT'
            secretRef: 'azure-cosmos-db-nosql-endpoint'
          }
          {
            name: 'AZURE_CLIENT_ID'
            secretRef: 'user-assigned-managed-identity-client-id'
          }
        ]
      }
    ]
  }
}

output jsEndpoint string = 'https://${containerAppsJsApp.outputs.fqdn}'
output tsEndpoint string = 'https://${containerAppsTsApp.outputs.fqdn}'
output envName string = containerAppsJsApp.outputs.name
output jsSystemAssignedManagedIdentityPrincipalId string = containerAppsJsApp.outputs.systemAssignedMIPrincipalId
output tsSystemAssignedManagedIdentityPrincipalId string = containerAppsTsApp.outputs.systemAssignedMIPrincipalId
