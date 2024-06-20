@description('The name of the Buget Alert')
param budgetName string

@description('The limit of the budget')
param limit int = 100

@description('The email of the owner of the budget')
param email string

@description('The start date of the budget')
param startDate string

@description('The name of the resource group to monitor')
param resourceGroupName string = resourceGroup().name

var firstThreshold = 50
var secondThreshold = 90

resource budget 'Microsoft.Consumption/budgets@2023-11-01' = {
  name: budgetName
  properties: {
    amount: limit
    category: 'Cost'
    timeGrain: 'BillingMonth'
    timePeriod: {
      startDate: startDate
    }
    notifications: {
      NotificationForExceededBudget1: {
        contactEmails: [
          email
        ]
        enabled: true 
        operator: 'GreaterThanOrEqualTo'
        threshold: firstThreshold
      }
      NotificationForExceededBudget2: {
        contactEmails: [
          email
        ]
        enabled: true 
        operator: 'GreaterThanOrEqualTo'
        threshold: secondThreshold
      }
    }
    filter: {
      dimensions: {
        name: 'ResourceGroupName'
        operator: 'In'
        values: [
          resourceGroupName
        ]
      }
    }
  }
}
