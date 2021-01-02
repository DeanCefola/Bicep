param VMName string
param adminusername string
param adminpassword string {
  secure:true
}
param location string = resourceGroup().location

module security './2-nsg.bicep' = {
  name: 'security'
  params:{
    NSGName: 'nsg-1'
    location: location
  }
}

