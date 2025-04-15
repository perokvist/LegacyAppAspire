param name string

@description('Azure region of the deployment')
param location string = resourceGroup().location

resource registry_resource 'Microsoft.ContainerRegistry/registries@2024-11-01-preview' = {
  name: name
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    adminUserEnabled: false
  }
}