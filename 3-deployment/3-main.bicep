// PARAMETERS //
param webappName string = 'lfa'
@secure()
param acrPassword string
@secure()
param sqlServerPassword string

// VARIABLES //
var principal = '5f1ed457-d451-4f9b-9e0d-eeca89bd066c'
var contributorRole = 'b24988ac-6180-42a0-ab88-20f7382dd24c'

// RESOURCES //
// add user as contriburot to this resource group
resource rbac 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(resourceGroup().id)
  properties : {
    principalId: principal
    roleDefinitionId: contributorRole
  }
}
module appService '3-webapp.bicep' = {
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
module datatier '3-datatier.bicep' = {
  name: 'datadeploy'
  params: {
    AdminUserName: 'lntad'
    AdminPassword: sqlServerPassword
    DomainFQDN: 'MSAzureAcademy.com'
    Instance: 1
    OperatingSystem: 'Client'
    Optimize: true
    Prefix: 'VM'
    ProfilePath: '\\\\MSAzureAcademy.com\\CorpShares\\FSLogix'
    RegistrationToken: 'asdasdwd13d3d3d3d3d3dd3adada3da3da3da3dada3a'
    VnetRgName: 'WVDNetwork'
    VnetName: 'WVDNetwork'
    SubnetName: 'wvd'
    VMSize: 'Small'        
  }
}

