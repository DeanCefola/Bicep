param webappName string = 'lfa'
param acrPassword string {
  secure:true
}
param sqlServerPassword string {
  secure:true
}
param location string {
  default:'eastus'
   allowed: [
     'eastus'
     'westus'
     'uksouth'     
   ]
   metadata:{
     description: 'this is your location'
   }
}

module appService './webapp.bicep' = {
  name: 'lfadeploy'
  params:{
    webAppName:webappName
    arcName: 'lawrencefarmsantiqes'
    dockerImageAndTag: 'lfa/frontend:latest'
    dockerUserName: 'lfaAdmin'
    dockerPassword: acrPassword    
  }  
  dependsOn:[
    datatier
  ]
}

module datatier './datatier.bicep' = {
  name: 'datadeploy'
  params: {
    serverName: 'lfaserver'
    userName: 'adminuser'
    password: sqlServerPassword    
    dbName: 'lfadb'
  }
}

var principal = '5f1ed457-d451-4f9b-9e0d-eeca89bd066c'
var contributorRole = 'b24988ac-6180-42a0-ab88-20f7382dd24c'
// add user as contriburot to this resource group
resource rbac 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(resourceGroup().id)
  properties : {
    principalId: principal
    roleDefinitionId: contributorRole
  }
}