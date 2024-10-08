metadata description = 'Create an Azure Cosmos DB for Table role assignment.'

@description('Name of the target Azure Cosmos DB account.')
param targetAccountName string

@description('Id of the role definition to assign to the targeted principal and account.')
param roleDefinitionId string

@description('Id of the principal to assign the role definition for the account.')
param principalId string

@description('Scope of the role assignment. Defaults to the account.')
param scope string = '/'

resource account 'Microsoft.DocumentDB/databaseAccounts@2024-05-15' existing = {
  name: targetAccountName
}

resource assignment 'Microsoft.DocumentDB/databaseAccounts/tableRoleAssignments@2024-05-15' = {
  name: guid(roleDefinitionId, principalId, account.id)
  parent: account
  properties: {
    principalId: principalId
    roleDefinitionId: roleDefinitionId
    scope: '${account.id}${scope}'
  }
}

output id string = assignment.id
