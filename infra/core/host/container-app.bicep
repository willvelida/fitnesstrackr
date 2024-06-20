@description('The name of the Container App')
param appName string

@description('The Environment that the Container App will be deployed in')
param environmentName string

@description('The location that the Container App will be deployed to')
param location string

@description('The Tags that will be applied to the Container App')
param tags object

@description('The configuration for the Container App')
param configuration object

@description('The template of the Container App')
param template object

@description('The identity for the Container App')
param identity object

resource env 'Microsoft.App/managedEnvironments@2024-03-01' existing = {
  name: environmentName
}

resource containerApp 'Microsoft.App/containerApps@2024-03-01' = {
  name: appName
  location: location
  tags: tags
  identity: identity
  properties: {
    managedEnvironmentId: env.id
    template: template
    configuration: configuration
  }
}

@description('The name of the Container App')
output name string = containerApp.name

@description('The FQDN of the Container App')
output fqdn string = containerApp.properties.configuration.ingress.fqdn

