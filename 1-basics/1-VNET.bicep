// PARAMETERS //
param Prefix string
param vnetIPs array = [
  '10.0.0.0/16'
  '10.1.0.0/16'
]
param vnetSubName string = 'subnet1'
param vnetSubIPs string = '10.0.50.0/24'
// VARIABLES //
var vnetName = '${Prefix}vnet1' 
var nsgName = '${Prefix}nsg1'
// RESOURCES //
resource nsg1 'Microsoft.Network/networkSecurityGroups@2020-06-01' = {
  location: resourceGroup().location
  name: nsgName
}
  
resource vnet1 'Microsoft.Network/virtualNetworks@2020-06-01' = {
  name: vnetName
  location: resourceGroup().location
  properties:{
    addressSpace:{
      addressPrefixes: vnetIPs
    }
    subnets:[
      {
        name: vnetSubName
        properties:{
          addressPrefix: vnetSubIPs
          networkSecurityGroup: {
            id:nsg1.id
          }
        }
      }
    ]
  }
}