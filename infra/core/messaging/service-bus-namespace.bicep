@description('The name of the Service Bus Namespace')
param serviceBusName string

@description('The location where the Service Bus will be deployed to')
param location string

@description('The name of the MSI that this Service Bus will use')
param msiName string

@description('The tags that will be applied to the Service Bus resource')
param tags object

var serviceBusDataReceiverRole = subscriptionResourceId('Microsoft.Authorization/roleDefinitions','4f6d3b9b-027b-4f4c-9142-0e5a2a2247e0')
var serviceBusDataSenderRole = subscriptionResourceId('Microsoft.Authorization/roleDefinitions','69a216fc-b8fb-44d8-bc22-1f3c2cd27a39')

resource msi 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' existing = {
  name: msiName
}

resource serviceBus 'Microsoft.ServiceBus/namespaces@2022-10-01-preview' = {
  name: serviceBusName
  location: location
  tags: tags
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${msi.id}': {}
    }
  }
  sku: {
    name: 'Basic'
  }
}

resource serviceBusSenderRole 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(serviceBus.id, msi.id, serviceBusDataSenderRole)
  properties: {
    principalId: msi.properties.principalId
    roleDefinitionId: serviceBusDataSenderRole
    principalType: 'ServicePrincipal'
  }
}

resource serviceBusReceiverRole 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(serviceBus.id, msi.id, serviceBusDataReceiverRole)
  properties: {
    principalId: msi.properties.principalId
    roleDefinitionId: serviceBusDataReceiverRole
    principalType: 'ServicePrincipal'
  }
}

@description('The name of the deployed service bus')
output serviceBusName string = serviceBus.name
