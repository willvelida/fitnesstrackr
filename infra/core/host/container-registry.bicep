@description('The name of the Container Registry')
param name string

@description('The location where the Container Registry will be deployed to')
param location string

@description('The tags that will be applied to the Container Registry')
param tags object

@description('The name of the identity that will be used to access the Container Registry')
param msiName string

var acrPullRoleId = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '7f951dda-4ed3-4680-a7ca-43fe172d538d')

resource msi 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' existing = {
  name: msiName
}

resource acr 'Microsoft.ContainerRegistry/registries@2023-07-01' = {
  name: name
  location: location
  tags: tags
  sku: {
    name: 'Basic'
  }
  properties: {
    adminUserEnabled: true
  }
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${msi.id}': {}
    }
  }
}

resource acrPullRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(acr.id, acrPullRoleId)
  scope: acr 
  properties: {
    roleDefinitionId: acrPullRoleId
    principalId: msi.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

@description('The name of the created Azure Container Registry')
output acrName string = acr.name
