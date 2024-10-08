metadata description = 'Create an Azure Cosmos DB for NoSQL account.'

param name string
param location string = resourceGroup().location
param tags object = {}

@description('Enables serverless for this account. Defaults to false.')
param enableServerless bool = false

@description('Disables key-based authentication. Defaults to true.')
param disableKeyBasedAuth bool = true

module account '../account.bicep' = {
  name: 'cosmos-db-nosql-account'
  params: {
    name: name
    location: location
    tags: tags
    kind: 'GlobalDocumentDB'
    enableServerless: enableServerless
    disableKeyBasedAuth: disableKeyBasedAuth
  }
}

output endpoint string = 'https://${account.outputs.name}.documents.azure.com:443/'
output name string = account.outputs.name
