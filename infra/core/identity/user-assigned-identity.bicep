@description('The name of the User Assigned Identity')
param userAssignedIdentityName string

@description('The Location where the user assigned identity will be deployed')
param location string

@description('The tags that will be applied to the User Assigned Identity')
param tags object

resource msi 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: userAssignedIdentityName
  location: location
  tags: tags
}

@description('The name of the created User Assigned Identity')
output name string = msi.name
