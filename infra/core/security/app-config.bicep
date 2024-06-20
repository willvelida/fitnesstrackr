@description('The name of the App Configuration service')
param appConfigName string

@description('The location that the App Configuration resource will be deployed to')
param location string

@description('The tags that will be applied to the App Config resource')
param tags object

@description('The name of the MSI that will be attached to the App Config resource')
param msiName string

var appConfigDataReaderRoleId = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '516239f1-63e1-4d78-a4de-a74fb236a071')

resource msi 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-07-31-preview' existing = {
  name: msiName
}

resource appConfig 'Microsoft.AppConfiguration/configurationStores@2023-03-01' = {
  name: appConfigName
  location: location
  tags: tags
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${msi.id}': {}
    }
  }
  sku: {
    name: 'free'
  }
}

resource appConfigReaderRole 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(appConfig.id, msi.id, appConfigDataReaderRoleId)
  properties: {
    principalId: msi.properties.principalId
    roleDefinitionId: appConfigDataReaderRoleId
    principalType: 'ServicePrincipal'
  }
}

@description('The name of the App Configuration service')
output name string = appConfig.name
