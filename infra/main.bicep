targetScope = 'subscription'

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
param cosmosDbAccountName string = ''
param containerRegistryName string = ''
param containerAppsEnvName string = ''
param containerAppsTypeScriptAppName string = ''
param containerAppsJavaScriptAppName string = ''
param userAssignedIdentityName string = ''

// serviceName is used as value for the tag (azd-service-name) azd uses to identify deployment host
param typeScriptServiceName string = 'typescript-web'
param javaScriptServiceName string = 'javascript-web'

var abbreviations = loadJsonContent('abbreviations.json')
var resourceToken = toLower(uniqueString(subscription().id, environmentName, location))
var tags = {
  'azd-env-name': environmentName
  repo: 'https://github.com/azure-samples/cosmos-db-nosql-nodejs-quickstart'
}

resource resourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: environmentName
  location: location
  tags: tags
}

module identity 'app/identity.bicep' = {
  name: 'identity'
  scope: resourceGroup
  params: {
    identityName: !empty(userAssignedIdentityName)
      ? userAssignedIdentityName
      : '${abbreviations.userAssignedIdentity}-${resourceToken}'
    location: location
    tags: tags
  }
}

module database 'app/database.bicep' = {
  name: 'database'
  scope: resourceGroup
  params: {
    accountName: !empty(cosmosDbAccountName) ? cosmosDbAccountName : '${abbreviations.cosmosDbAccount}-${resourceToken}'
    location: location
    tags: tags
  }
}

module registry 'app/registry.bicep' = {
  name: 'registry'
  scope: resourceGroup
  params: {
    registryName: !empty(containerRegistryName)
      ? containerRegistryName
      : '${abbreviations.containerRegistry}${resourceToken}'
    location: location
    tags: tags
  }
}

module environment 'app/environment.bicep' = {
  name: 'environment'
  scope: resourceGroup
  params: {
    envName: !empty(containerAppsEnvName) ? containerAppsEnvName : '${abbreviations.containerAppsEnv}-${resourceToken}'
    location: location
    tags: tags
  }
}

module jsweb 'app/web.bicep' = {
  name: javaScriptServiceName
  scope: resourceGroup
  params: {
    appName: !empty(containerAppsJavaScriptAppName) ? containerAppsJavaScriptAppName : '${abbreviations.containerAppsApp}-js-${resourceToken}'
    envName: environment.outputs.name
    databaseAccountEndpoint: database.outputs.endpoint
    userAssignedManagedIdentity: {
      resourceId: identity.outputs.resourceId
      clientId: identity.outputs.clientId
    }
    location: location
    tags: tags
    serviceTag: javaScriptServiceName
  }
}

module tsweb 'app/web.bicep' = {
  name: typeScriptServiceName
  scope: resourceGroup
  params: {
    appName: !empty(containerAppsTypeScriptAppName) ? containerAppsTypeScriptAppName : '${abbreviations.containerAppsApp}-ts-${resourceToken}'
    envName: environment.outputs.name
    databaseAccountEndpoint: database.outputs.endpoint
    userAssignedManagedIdentity: {
      resourceId: identity.outputs.resourceId
      clientId: identity.outputs.clientId
    }
    location: location
    tags: tags
    serviceTag: typeScriptServiceName
  }
}

module security 'app/security.bicep' = {
  name: 'security'
  scope: resourceGroup
  params: {
    databaseAccountName: database.outputs.accountName
    appPrincipalId: identity.outputs.principalId
    userPrincipalId: !empty(principalId) ? principalId : null
  }
}

// Database outputs
output AZURE_COSMOS_DB_ENDPOINT string = database.outputs.endpoint
output AZURE_COSMOS_DB_DATABASE_NAME string = database.outputs.database.name
output AZURE_COSMOS_DB_CONTAINER_NAMES array = map(database.outputs.containers, c => c.name)

// Container outputs
output AZURE_CONTAINER_REGISTRY_ENDPOINT string = registry.outputs.endpoint
output AZURE_CONTAINER_REGISTRY_NAME string = registry.outputs.name

// Application outputs
output AZURE_CONTAINER_ENVIRONMENT_NAME string = environment.outputs.name
output AZURE_CONTAINER_APP_JS_ENDPOINT string = jsweb.outputs.endpoint
output AZURE_CONTAINER_APP_TS_ENDPOINT string = tsweb.outputs.endpoint

// Identity outputs
output AZURE_USER_ASSIGNED_IDENTITY_NAME string = identity.outputs.name

// Security outputs
output AZURE_NOSQL_ROLE_DEFINITION_ID string = security.outputs.roleDefinitions.nosql
