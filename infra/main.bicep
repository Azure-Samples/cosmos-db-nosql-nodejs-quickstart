targetScope = 'resourceGroup'

@minLength(1)
@maxLength(64)
@description('Name of the environment that can be used as part of naming resource convention.')
param environmentName string

@minLength(1)
@description('Primary location for all resources.')
param location string

@description('Id of the principal to assign database and application roles.')
param principalId string = ''

// Optional parameters
param logWorkspaceName string = ''
param cosmosDbAccountName string = ''
param containerRegistryName string = ''
param containerAppsEnvName string = ''
param containerAppsTypeScriptAppName string = ''
param containerAppsJavaScriptAppName string = ''

// serviceName is used as value for the tag (azd-service-name) azd uses to identify deployment host
param typeScriptServiceName string = 'typescript-web'
param javaScriptServiceName string = 'javascript-web'

var abbreviations = loadJsonContent('abbreviations.json')
var resourceToken = toLower(uniqueString(resourceGroup().id, environmentName, location))
var tags = {
  'azd-env-name': environmentName
  repo: 'https://github.com/azure-samples/cosmos-db-nosql-nodejs-quickstart'
}

module identity 'app/identity.bicep' = {
  name: 'identity'
  params: {
    identityName: '${abbreviations.userAssignedIdentity}-${resourceToken}'
    location: location
    tags: tags
  }
}

module database 'app/database.bicep' = {
  name: 'database'
  params: {
    accountName: !empty(cosmosDbAccountName) ? cosmosDbAccountName : '${abbreviations.cosmosDbAccount}-${resourceToken}'
    location: location
    tags: tags
    appPrincipalId: identity.outputs.principalId
    userPrincipalId: !empty(principalId) ? principalId : null
  }
}

module registry 'app/registry.bicep' = {
  name: 'registry'
  params: {
    registryName: !empty(containerRegistryName) ? containerRegistryName : '${abbreviations.containerRegistry}${resourceToken}'
    location: location
    tags: tags
  }
}

module web 'app/web.bicep' = {
  name: 'web'
  params: {
    workspaceName: !empty(logWorkspaceName) ? logWorkspaceName : '${abbreviations.logAnalyticsWorkspace}-${resourceToken}'
    envName: !empty(containerAppsEnvName) ? containerAppsEnvName : '${abbreviations.containerAppsEnv}-${resourceToken}'
    jsAppName: !empty(containerAppsJavaScriptAppName) ? containerAppsJavaScriptAppName : '${abbreviations.containerAppsApp}-js-${resourceToken}'
    tsAppName: !empty(containerAppsTypeScriptAppName) ? containerAppsTypeScriptAppName : '${abbreviations.containerAppsApp}-ts-${resourceToken}'
    location: location
    tags: tags
    jsServiceTag: javaScriptServiceName
    tsServiceTag: typeScriptServiceName
    appResourceId: identity.outputs.resourceId
    appClientId: identity.outputs.clientId
    databaseAccountEndpoint: database.outputs.endpoint
  }
}

output AZURE_COSMOS_DB_NOSQL_ENDPOINT string = database.outputs.endpoint
output AZURE_CONTAINER_REGISTRY_ENDPOINT string = registry.outputs.endpoint
