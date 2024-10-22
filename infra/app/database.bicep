metadata description = 'Create database accounts.'

param accountName string
param location string = resourceGroup().location
param tags object = {}

@description('Id of the service principals to assign database and application roles.')
param appPrincipalId string

@description('Id of the user principals to assign database and application roles.')
param userPrincipalId string = ''

module cosmosDbAccount 'br/public:avm/res/document-db/database-account:0.6.1' = {
  name: 'cosmos-db-account'
  params: {
    name: accountName
    location: location
    locations: [
      {
        failoverPriority: 0
        locationName: location
        isZoneRedundant: false
      }
    ]
    tags: tags
    disableKeyBasedMetadataWriteAccess: true
    disableLocalAuth: true
    capabilitiesToAdd: [
      'EnableServerless'
    ]
    sqlRoleDefinitions: [
      {
        name: 'nosql-data-plane-contributor'
        dataAction: [
          'Microsoft.DocumentDB/databaseAccounts/readMetadata'
          'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/items/*'
          'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/*'     
        ]
      }
    ]
    sqlRoleAssignmentsPrincipalIds: union(
      [
        appPrincipalId
      ],
      !empty(userPrincipalId)
        ? [
            userPrincipalId
          ]
        : []
    )
    sqlDatabases: [
      {
        name: 'cosmicworks'
        containers: [
          {
            name: 'products'
            paths: [
              '/category'
            ]
          }
        ]
      }
    ]
  }
}

output endpoint string = cosmosDbAccount.outputs.endpoint
