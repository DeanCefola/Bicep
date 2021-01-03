param Prefix string
param vnetName string
param vnetIPs array 
param vnetSubIPs string
param nsg1Id string
param location string
  
resource vnet1 'Microsoft.Network/virtualNetworks@2020-06-01' = {
  name: vnetName
  location: resourceGroup().location
  properties:{
    addressSpace:{
      addressPrefixes: vnetIPs
    }
    subnets:[
      {
        name: 'subnet1'
        properties:{
          addressPrefix: vnetSubIPs
          networkSecurityGroup: {
            id:nsg1Id
          }
        }
      }
    ]
  }
}
output vnetId string = vnet1.id
output subnetId string = '${vnet1.id}/subnets/{vnetSubName}'