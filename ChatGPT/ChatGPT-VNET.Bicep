param location string = 'eastus2'
param VNETName string = 'ChatGPT-VNET'

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2022-07-01' = {
  name: VNETName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'AzureGatewaySubnet'
        properties: {
          addressPrefix: '10.0.0.0/24'
        }
      }
      {
        name: 'AzureFirewallSubnet'
        properties: {
          addressPrefix: '10.0.1.0/24'
        }
      }
      {
        name: 'AzureBastionSubnet'
        properties: {
          addressPrefix: '10.0.2.0/24'
        }
      }
      {
        name: 'Application'
        properties: {
          addressPrefix: '10.0.3.0/24'
        }
      }
    ]
  }
}
