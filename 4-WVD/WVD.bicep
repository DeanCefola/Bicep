resource hostPool 'Microsoft.DesktopVirtualization/hostpools@2019-12-10-preview' = {
  name: 'Bicep-Pool'
  location: resourceGroup().location
  properties: {
    friendlyName: 'Bicep-Pool'
    hostPoolType: 'Pooled'
    loadBalancerType: 'BreadthFirst'
    preferredAppGroupType:'RailApplications'
  }
}
resource applicationGroup 'Microsoft.DesktopVirtualization/applicationgroups@2019-12-10-preview' = {
  name: 'Bicep-Apps'
  location: resourceGroup().location
  properties: {
    friendlyName: 'Bicep-Apps'
    applicationGroupType: 'RemoteApp'
    hostPoolArmPath: resourceId('Microsoft.DesktopVirtualization/hostpools', 'REQUIRED')
  }
}
resource workSpace 'Microsoft.DesktopVirtualization/workspaces@2019-12-10-preview' = {
  name: 'Bicep-WS'
  location: resourceGroup().location
  properties: {
    friendlyName: 'Bicep-WS'
  }
}
