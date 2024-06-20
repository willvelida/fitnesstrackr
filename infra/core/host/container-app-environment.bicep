@description('The name of the Container App Environment')
param envName string

@description('The location where the environment will be deployed')
param location string

@description('The name of the Log Analytics Workspace that this Container App will send logs to')
param logAnalyticsWorkspaceName string

@description('The tags that will be applied to the Container App environment')
param tags object

resource law 'Microsoft.OperationalInsights/workspaces@2023-09-01' existing = {
  name: logAnalyticsWorkspaceName
}

resource env 'Microsoft.App/managedEnvironments@2024-03-01' = {
  name: envName
  location: location
  tags: tags
  properties: {
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: law.properties.customerId
        sharedKey: law.listKeys().primarySharedKey
      }
    }
  }
}

@description('The name of the created Container App Environment')
output name string = env.name
