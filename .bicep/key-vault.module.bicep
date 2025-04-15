param name string

@description('Location for all resources.')
param location string = resourceGroup().location

param tenantId string = subscription().tenantId
param publicNetworkAccess string = 'disabled'


resource key_vault_resource 'Microsoft.KeyVault/vaults@2024-12-01-preview' = {
  name: name
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: tenantId
    accessPolicies: []
    publicNetworkAccess: publicNetworkAccess
  }
}

// resource vaults_legacy_sample_kv_name_azure_sql_connectionstring_f914a 'Microsoft.KeyVault/vaults/secrets@2024-12-01-preview' = {
//   parent: key_vault_resource
//   name: 'azure-sql-connectionstring-f914a'
//   properties: {
//     attributes: {
//       enabled: true
//     }
//   }
// }

output keyVaultId string = key_vault_resource.id
