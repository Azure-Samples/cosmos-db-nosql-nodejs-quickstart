metadata description = 'Create container registries.'

param registryName string
param location string = resourceGroup().location
param tags object = {}

@description('Id of the user principals to assign database and application roles.')
param userPrincipalId string = ''

module containerRegistry 'br/public:avm/res/container-registry/registry:0.5.1' = {
  name: 'container-registry'
  params: {
    name: registryName
    location: location
    tags: tags
    acrAdminUserEnabled: false
    anonymousPullEnabled: true
    publicNetworkAccess: 'Enabled'
    acrSku: 'Standard'
  }
}

module registryUserAssignment 'br/public:avm/ptn/authorization/resource-role-assignment:0.1.1' = if (!empty(userPrincipalId)) {
  name: 'container-registry-role-assignment-push-user'
  params: {
    principalId: userPrincipalId
    resourceId: containerRegistry.outputs.resourceId
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      '8311e382-0749-4cb8-b61a-304f252e45ec' // AcrPush built-in role
    )
  }
}

output name string = containerRegistry.outputs.name
output endpoint string = containerRegistry.outputs.loginServer
