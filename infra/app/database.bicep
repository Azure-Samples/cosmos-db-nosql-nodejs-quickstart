metadata description = 'Create database accounts.'

param accountName string
param location string = resourceGroup().location
param tags object = {}

@description('Id of the service principals to assign database and application roles.')
param appPrincipalId string

@description('Id of the user principals to assign database and application roles.')
param userPrincipalId string = ''

var database = {
  name: 'cosmicworks' // Based on AdventureWorksLT data set
}

var containers = [
  {
    name: 'products' // Set of products
    partitionKeyPaths: [
      '/category' // Partition on the product category
    ]
    autoscale: true // Scale at the container level
    throughput: 1000 // Enable autoscale with a minimum of 100 RUs and a maximum of 1,000 RUs
  }
]

module cosmosDbAccount 'br/public:avm/res/document-db/database-account:0.6.1' = {
  name: 'cosmos-db-account'
  params: {
    name: accountName
    location: location
    tags: tags
    disableKeyBasedMetadataWriteAccess: true
    disableLocalAuth: true
    sqlRoleDefinitions: [
      {
        name: 'nosql-data-plane-contributor'
        dataAction: [
          'Microsoft.DocumentDB/databaseAccounts/readMetadata' // Read account metadata
          'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/items/*' // Create items
          'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/*' // Manage items      
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
        name: database.name
        containers: [
          for container in containers: {
            name: container.name
            paths: container.partitionKeyPaths
            autoscaleSettingsMaxThroughput: container.throughput
          }
        ]
      }
    ]
  }
}

output name string = cosmosDbAccount.outputs.name
output endpoint string = cosmosDbAccount.outputs.endpoint
