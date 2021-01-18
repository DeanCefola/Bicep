param Prefix string
param vnetIPs string
param nsg1Id string
var vnetSubIPs = (vnetIPs)
var vnetName = '${Prefix}vnet01'
resource vnet1 'Microsoft.Network/virtualNetworks@2020-06-01' = {
  name: vnetName
  location: resourceGroup().location
  properties:{
    addressSpace:{
      addressPrefixes:[
        vnetIPs
      ]
    }
    subnets:[
      {
        name: 'subnet1'
        properties:{
          addressPrefix: vnetIPs
          networkSecurityGroup: {
            id:nsg1Id
          }
        }
      }
    ]
  }
}
output vnetId string = vnet1.id
output subnetId string = '${vnet1.id}/subnets/subnet1'