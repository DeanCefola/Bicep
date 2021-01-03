param webAppName string
param location string = resourceGroup().location

param arcName string
param dockerUserName string
param dockerPassword string
param dockerImageAndTag string

resource site 'Microsoft.Web/sites@2020-06-01' = {
  name: '${webAppName}-site'
  location: location
  properties: {
    siteConfig:{
      appSettings:[
        {
          name: 'DOCKER_REGISTRY_SERVER_URL'
          value: 'https://${arcName}.azurecr.io'
        }
        {
          name: 'DOCKER_REGISTRY_SERVER_USERNAME'
          value: dockerUserName
        }
        {
          name: 'DOCKER_REGISTRY_SERVER_PASSWORD'
          value: dockerPassword
        }
        {
          name: 'WEBSITES_ENABLED_APP_SERVICE_STORAGE'
          value: 'false' //swagger issue
        }
      ]
      linuxFxVersion: 'DOCKER|${arcName}.azure.io/${dockerImageAndTag}'
    }
    serverFarmId: farm.id //resourceId()
  }
}

resource farm 'Microsoft.Web/serverfarms@2020-06-01' = {
  name: webAppName
  location: location
  sku: {
    name: 'B1'
    tier: 'Basic'
  }
  kind: 'linux' //if kind=app -> windows
  properties: {
    targetWorkerSizeId: 0
    targetWorkerCount: 1
    reserved: true
  }
}

output websiteId string = site.id

