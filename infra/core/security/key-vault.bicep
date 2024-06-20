@description('The name of the Key Vault')
param keyVaultName string

@description('The location of the Key Vault')
param location string

@description('The tags that will be applied to the Key Vault')
param tags object

@description('The name of the MSI that this Key Vault will use')
param msiName string

var keyVaultSecretUserRoleId = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4633458b-17de-408a-b874-0445c86b69e6')

resource msi 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' existing = {
  name: msiName
}

resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: keyVaultName
  location: location
  tags: tags
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: subscription().tenantId
    enableRbacAuthorization: true
    enableSoftDelete: true
    enablePurgeProtection: true
    enabledForTemplateDeployment: true
    softDeleteRetentionInDays: 7
  }
}

resource keyVaultSecretUserRole 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(keyVault.id, msi.id, keyVaultSecretUserRoleId)
  properties: {
    principalId: msi.properties.principalId
    roleDefinitionId: keyVaultSecretUserRoleId
    principalType: 'ServicePrincipal'
  }
}

@description('The name of the created Key Vault')
output name string = keyVault.name
