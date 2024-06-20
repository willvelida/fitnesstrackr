@description('The name of the Application Insights workspace')
param appInsightsName string

@description('The location of the App Insights workspace')
param location string

@description('The Log Analytics workspace name that this App Insights resource will be linked to')
param logAnalyticsName string

@description('The tags that will be applied to the Log Analytics workspace')
param tags object

resource law 'Microsoft.OperationalInsights/workspaces@2023-09-01' existing = {
  name: logAnalyticsName
}

resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: appInsightsName
  location: location
  tags: tags
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: law.id
  } 
}

@description('The name of the created App Insights resource')
output name string = appInsights.name
