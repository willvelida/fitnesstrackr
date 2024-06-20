@description('The name of the Database that will be deployed')
param databaseName string

@description('The name of the account that this Database will be deployed to')
param accountName string

resource cosmosAccount 'Microsoft.DocumentDB/databaseAccounts@2024-05-15' existing = {
  name: accountName
}

resource database 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2024-05-15' = {
  name: databaseName
  parent: cosmosAccount
  properties: {
    resource: {
      id: databaseName
    }
    options: {
      throughput: 1000
    }
  }
}

@description('The name of the Database that will be created')
output name string = database.name
