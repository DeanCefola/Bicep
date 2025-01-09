param adminUsername string = 'lntad'
@secure()
param adminPassword string
param vmSize string = 'Standard_B2ms'
param location string = 'eastus2'
param vmName string = 'ChatGPT-VM'

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: 'ChatGPT-VNET'
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
        name: 'AzureFirwallSubnet'
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

resource Nic 'Microsoft.Network/networkInterfaces@2022-07-01' = {
  name: 'chatgptnic'
  location: location
  properties: {
      ipConfigurations: [{
          name: 'ipconfig1'
          properties: {
              privateIPAllocationMethod: 'Dynamic'
              subnet: {
                id: resourceId('Microsoft.Network/virtualNetworks/subnets', virtualNetwork.name, 'Application')
              }
          }
      }]
  }  
}

resource vm 'Microsoft.Compute/virtualMachines@2021-04-01' = {
  name: vmName
  location: location
  properties: {
      hardwareProfile: {
          vmSize: vmSize
      }      
      storageProfile: {
          osDisk: {
              createOption: 'FromImage'
              caching: 'ReadWrite'
              managedDisk: {
                  storageAccountType: 'StandardSSD_LRS'
              }
          }
          imageReference: {
              publisher: 'MicrosoftWindowsServer'
              offer: 'WindowsServer'
              sku: '2019-Datacenter'
              version: 'latest'
          }
      }
      osProfile: {
          computerName: vmName
          adminUsername: adminUsername
          adminPassword: adminPassword
          windowsConfiguration: {
              provisionVMAgent: true
              enableAutomaticUpdates: true
          }
      }
      networkProfile: {
          networkInterfaces: [
            {
              id: resourceId('Microsoft.Network/networkInterfaces', 'chatgptnic')
          }
        ]
      }      
  }
  dependsOn: [
    virtualNetwork
    Nic  
  ]
}
