@description('The name of the Container App Job')
param jobName string

@description('The Environment where the Job will be deployed to')
param environmentName string

@description('The location that the job will be deployed to')
param location string

@description('The Tags that will be applied to the Container App Job')
param tags object

@description('The configuration for the Container App Job')
param configuration object

@description('The template of the Container App Job')
param template object

@description('The identity for the Container App Job')
param identity object

resource env 'Microsoft.App/managedEnvironments@2024-03-01' existing = {
  name: environmentName
}

resource containerJob 'Microsoft.App/jobs@2024-03-01' = {
  name: jobName
  location: location
  tags: tags
  identity: identity
  properties: {
    environmentId: env.id
    template: template
    configuration: configuration
  }
}

@description('The name of the Container App Job')
output name string = containerJob.name
