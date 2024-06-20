@description('The location where all resources will be deployed. Default is the resource group location')
param location string = resourceGroup().location

@description('The name of the Log Analytics Workspace')
param logAnalyticsName string

@description('The name of the Application Insights resource')
param appInsightsName string

@description('The name of the Container App Environment')
param containerAppEnvName string

@description('The name of the Container Registry')
param containerRegistryName string

@description('The name of the user assigned identity')
param userAssignedIdentityName string

@description('The name of the Key Vault')
param keyVaultName string

@description('The name of the App Configuration Service')
param appConfigName string

@description('The name of the Service Bus Namespace')
param serviceBusName string

@description('The name of the Cosmos DB Account')
param cosmosDbAccountName string

@description('The name of the Cosmos DB Database')
param cosmosDatabaseName string

@description('The name of the Budget')
param budgetName string

@description('The email of the owner of the budget')
param email string

@description('The start date of the budget')
param startDate string

@description('The tags that will be applied to the resources')
param tags object = {
  ApplicationName: 'fitnesstrackr'
  Owner: 'Will Velida'
  Environment: 'Production'
}

module budget 'monitor/budget-alert.bicep' = {
  name: 'budget'
  params: {
    budgetName: budgetName
    email: email
    startDate: startDate
  }
}

module law 'monitor/log-analytics.bicep' = {
  name: 'law'
  params: {
    location: location 
    logAnalyticsWorkspaceName: logAnalyticsName
    tags: tags
  }
}

module appInsights 'monitor/app-insights.bicep' = {
  name: 'appins'
  params: {
    appInsightsName: appInsightsName 
    location: location
    logAnalyticsName: law.outputs.name
    tags: tags
  }
}

module cosmos 'database/cosmos-account.bicep' = {
  name: 'cosmosdb'
  params: {
    accountName: cosmosDbAccountName
    location: location
    msiName: msi.outputs.name
    tags: tags
  }
}

module cosmosDatabase 'database/cosmos-database.bicep' = {
  name: 'cosmos-database'
  params: {
    accountName: cosmos.outputs.name
    databaseName: cosmosDatabaseName
  }
}

module msi 'identity/user-assigned-identity.bicep' = {
  name: 'msi'
  params: {
    location: location 
    tags: tags
    userAssignedIdentityName: userAssignedIdentityName
  }
}

module kv 'security/key-vault.bicep' = {
  name: 'kv'
  params: {
    keyVaultName: keyVaultName 
    location: location
    tags: tags
    msiName: msi.outputs.name
  }
}

module appConfig 'security/app-config.bicep' = {
  name: 'appconfig'
  params: {
    appConfigName: appConfigName
    location: location
    tags: tags
    msiName: msi.outputs.name
  }
}

module serviceBus 'messaging/service-bus-namespace.bicep' = {
  name: 'sb'
  params: {
    location: location 
    msiName: msi.outputs.name
    serviceBusName: serviceBusName
    tags: tags
  }
}

module acr 'host/container-registry.bicep' = {
  name: 'acr'
  params: {
    location: location 
    msiName: msi.outputs.name
    name: containerRegistryName
    tags: tags
  }
}

module env 'host/container-app-environment.bicep' = {
  name: 'env'
  params: {
    envName: containerAppEnvName
    location: location
    logAnalyticsWorkspaceName: law.outputs.name
    tags: tags
  }
}
