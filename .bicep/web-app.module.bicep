@description('The name of the web application.')
param name string

@description('The ID of the App Service plan.')
param planId string

@description('Location for all resources.')
param location string = resourceGroup().location

// Security
@description('The type of identity to assign to the web application. Default is SystemAssigned.')
param identityType string = 'SystemAssigned'

@description('Indicates whether a system-assigned identity should be enabled for the web application.')
param systemIdentity bool = false

// Key Vault
@description('The name of the Azure Key Vault to be used.')
param vaultName string

// Application Insights
@description('The name of the Application Insights resource.')
param applicationInsightsName string

// Registry
@description('The name of the Azure Container Registry.')
param registryName string

// DB
@description('The full (uri) name of the SQL Server.')
param sqlServerFullyQualifiedDomainName string

@description('The name of the SQL Server.')
param sqlServerName string

@description('The name of the SQL Database.')
param sqlDBName string

// Deployment
@description('The name of the container image to deploy.')
param containerName string = 'legacy-sample'

@description('The tag of the container image to deploy.')
param containerTag string = 'latest'
// ### Resources ###

resource registry 'Microsoft.ContainerRegistry/registries@2024-11-01-preview' existing = {
  name: registryName
}

resource logService 'Microsoft.Insights/components@2020-02-02' existing = {
  name: applicationInsightsName
}


// resource userAssignedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
//   name: userAssignedIdentityName
//   location: location
// }

resource appService 'Microsoft.Web/sites@2024-04-01' = {
  name: name
  location: location
  kind: 'app,linux,container'
  properties: {
    serverFarmId: planId
    siteConfig: {
      linuxFxVersion: 'DOCKER|${registry.name}.azurecr.io/${containerName}:${containerTag}'
      healthCheckPath: '/health'
      // connectionStrings: [
      //   {
      //     name: connectionStringName
      //     connectionString: connectionString
      //     type: 'SQLAzure'
      //   }
      // ]
      appSettings: [
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: logService.properties.ConnectionString
        }
        {
          name: 'XDT_MicrosoftApplicationInsights_Mode'
          value: 'recommended'
        }
                {
          name: 'DOCKER_REGISTRY_SERVER_URL'
          value: 'https://${registry.name}.azurecr.io'
        }
        {
          name: 'DOCKER_REGISTRY_SERVER_USERNAME'
          value: ''
        }
        {
          name: 'DOCKER_REGISTRY_SERVER_PASSWORD'
          value: ''
        }
      ]
    }
  }
  // identity: {
  //   type: 'UserAssigned'
  //   userAssignedIdentities: {
  //     '${userAssignedIdentity.id}': {}
  //   }
  identity: {
    type: identityType
  }
}

param connectors array = [
   {
    name: 'key_vault_connector_${uniqueString(resourceGroup().id)}'
    id: resourceId('Microsoft.KeyVault/vaults', vaultName)
    authInfo: {
        authType: 'systemAssignedIdentity'
    }
    // authInfo: {
    //   authType: 'UserAssignedIdentity'
    //   clientId: userAssignedIdentity.properties.clientId
    // }
   }
   {
    name: 'sql_connector_${uniqueString(resourceGroup().id)}'
    id: resourceId('Microsoft.Sql/servers/databases', sqlServerName, sqlDBName)
    authInfo: {
      authType: 'Secret'
      secretInfo: {
        name: 'ConnectionStrings__database'
        value: 'Server=tcp:${sqlServerFullyQualifiedDomainName},1433;Database=${sqlDBName};Initial Catalog=${sqlDBName};Authentication=Active Directory Managed Identity'
      }
    }
  }
]

resource serviceConnectors 'Microsoft.ServiceLinker/linkers@2024-07-01-preview' = [
  for connector in connectors: if (systemIdentity) {
    name: connector.name
    scope: appService
    properties: {
      clientType: 'dotnet'
      targetService: {
        type: 'AzureResource'
        id: connector.id
      }
      authInfo: connector.authInfo
    }
  }
]

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(appService.id, 'acrpull')
  scope: registry
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '7f951dda-4ed3-4680-a7ca-43fe172d538d') // AcrPull role
    principalId: appService.identity.principalId
  }
}
