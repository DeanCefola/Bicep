param NSGName string = 'nsg-1'
resource nsg 'Microsoft.Network/networkSecurityGroups@2020-06-01' = {  
  name:NSGName
  location:resourceGroup().location
  properties:{
    securityRules:[
      {
        name: 'AllowedRDP'
        properties:{
          description: ''
          direction:'Inbound'
          access:'Allow'
          priority: 500
          protocol:'Tcp'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '3389'
        }
      }
    ]
  }
}