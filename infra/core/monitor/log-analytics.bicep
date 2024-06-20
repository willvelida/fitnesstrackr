@description('The name of the Log Analytics workspace')
param logAnalyticsWorkspaceName string

@description('The location to deploy the workspace')
param location string

@description('The tags that will be applied to the Log Analytics workspace')
param tags object

resource law 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: logAnalyticsWorkspaceName
  location: location
  tags: tags
  properties: {
    sku: {
      name: 'PerGB2018'
    }
  }
}

@description('The name of the created Log Analytics workspace')
output name string = law.name
