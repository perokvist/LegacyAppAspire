param env string
param name string = 'legacy-sample-${env}'

// Security
param systemidentity bool = true
param publicNetworkAccess string = systemidentity ? 'disabled' : 'enabled'

// Registry
param registryName string = replace('${name}-cr', '-', '')

// DB
param sqlname string = '${name}-sql'
param sqldbname string = '${name}-sqldb'
param sqladministratorlogin string = 'legacy-sample-test'
@secure()
param sqladministratorloginpassword string = 'Ivenhoe-2025-#-${newGuid()}'


// Log
param logAnalyticsWorkspaceName string = '${name}-log'
param applicationInsightsName string = '${name}-appi'

// Key Vault
param vaultName string = '${name}-kv'


// ### Modules ###

module registryModule 'container-registry.module.bicep' = {
  name: 'registry'
  params: {
   name: registryName
  }
}

module sqlModule 'sql_database.module.bicep' = {
  name: 'sql'
  params: {
    serverName: sqlname
    sqlDBName: sqldbname
    administratorLogin: sqladministratorlogin
    administratorLoginPassword: sqladministratorloginpassword
    systemIdentity: systemidentity
    publicNetworkAccess:publicNetworkAccess
  }
}

module insightsModule 'app_insights.module.bicep' = {
  name: 'insights'
  params: {
    applicationInsightsName: applicationInsightsName
    logAnalyticsWorkspaceName: logAnalyticsWorkspaceName
  }
}

module vaultModule 'key-vault.module.bicep' = {
  name: 'keyVault'
   params: {
        name: vaultName
  }
}

module planModule 'web-app-plan.module.bicep' = {
  name: 'plan'
  params: {
    name: '${name}-asp'
  }
}

module appModule 'web-app.module.bicep' = {
  name: 'app'
  params: {
    name: '${name}-app'
    planId: planModule.outputs.planId
    applicationInsightsName: applicationInsightsName
    sqlServerName: sqlname
    sqlDBName: sqldbname
    sqlServerFullyQualifiedDomainName: sqlModule.outputs.serverFullyQualifiedDomainName
    systemIdentity: systemidentity
    vaultName: vaultName
    registryName: registryName
  }
  dependsOn: [insightsModule, registryModule, vaultModule]
}
