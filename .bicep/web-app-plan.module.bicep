param name string

@description('Location for all resources.')
param location string = resourceGroup().location

resource appServicePlan 'Microsoft.Web/serverfarms@2024-04-01' = {
  name: name
  location: location
  sku: {
    name: 'B1'
    tier: 'Basic'
    size: 'B1'
    family: 'B'
    capacity: 1
  }
  kind: 'linux'
  properties: {
    maximumElasticWorkerCount: 1
    reserved: true
    zoneRedundant: false
  }
}

output planId string = appServicePlan.id
