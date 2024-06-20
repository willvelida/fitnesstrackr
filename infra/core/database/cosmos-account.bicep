@description('The name of the Cosmos DB account')
param accountName string

@description('The location where the Cosmos DB account will be deployed')
param location string

@description('The name of the MSI that the Cosmos DB account will use')
param msiName string

@description('The tags that will be applied to the Cosmos DB account')
param tags object

resource msi 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' existing = {
  name: msiName
}

resource cosmosAccount 'Microsoft.DocumentDB/databaseAccounts@2024-05-15' = {
  name: accountName
  tags: tags
  location: location
  kind: 'GlobalDocumentDB'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${msi.id}': {}
    }
  }
  properties: {
    databaseAccountOfferType: 'Standard' 
    locations: [
      {
        locationName: location
      }
    ]
    consistencyPolicy: {
      defaultConsistencyLevel: 'Session'
    }
    enableFreeTier: true
  }
}

@description('The name of the Cosmos DB account')
output name string = cosmosAccount.name
