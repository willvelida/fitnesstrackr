@description('The name of the queue')
param queueName string

@description('The namespace that the queue will be deployed to')
param namespace string

resource serviceBus 'Microsoft.ServiceBus/namespaces@2022-10-01-preview' existing = {
  name: namespace
}

resource queue 'Microsoft.ServiceBus/namespaces/queues@2022-10-01-preview' = {
  name: queueName
  parent: serviceBus
}

@description('The name of the created queue')
output queueName string = queue.name
