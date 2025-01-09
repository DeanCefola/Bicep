param adminUsername string = 'newadmin'
@secure()
param adminPassword string
param vmSize string = 'Standard_B4ms'
param location string = 'eastus2'
param vmName string = 'NewVM'

resource newVM 'Microsoft.Compute/virtualMachines@2021-04-01' = {
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
              publisher: 'microsoftwindowsdesktop'
              offer: 'windows11preview'
              sku: 'win11-22h2-ent'
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
              id: resourceId('Microsoft.Network/networkInterfaces', 'newVMnic')
          }
        ]
      }      
  }
  dependsOn: [
    Nic
  ]
}

resource Nic 'Microsoft.Network/networkInterfaces@2022-07-01' = {
  name: 'newVMnic'
  location: location
  properties: {
      ipConfigurations: [{
          name: 'ipconfig1'
          properties: {
              privateIPAllocationMethod: 'Dynamic'
              subnet: {
                id: resourceId('Microsoft.Network/virtualNetworks/subnets', 'ChatGPT-VNET', 'Application')
              }
          }
      }]
  }  
}
