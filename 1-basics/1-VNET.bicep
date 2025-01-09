// PARAMETERS //
param Prefix string
param vnetIPs array = [
  '10.0.0.0/16'
  '10.1.0.0/16'
]
param vnetSubName string = 'subnet1'
param vnetSubIPs string = '10.0.50.0/24'
param VMName string
@secure()
param AdminPassword string 

// VARIABLES //
var vnetName = '${Prefix}vnet1' 
var nsgName = '${Prefix}nsg1'
var location = resourceGroup().location
// RESOURCES //
resource nsg1 'Microsoft.Network/networkSecurityGroups@2020-06-01' = {
  location: location
  name: nsgName
}  
resource vnet1 'Microsoft.Network/virtualNetworks@2020-06-01' = {
  name: vnetName
  location: location
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

resource networkInterface 'Microsoft.Network/networkInterfaces@2020-11-01' = {
  name: 'Nic'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'name'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: 'subnet.id'
          }
        }
      }
    ]
  }
}
resource windowsVM 'Microsoft.Compute/virtualMachines@2020-12-01' = {
  name: 'VMName'
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_A2_v2'
    }
    osProfile: {
      computerName: 'VMName'
      adminUsername: 'adminUsername'
      adminPassword: AdminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2012-R2-Datacenter'
        version: 'latest'
      }
      osDisk: {
        name: 'VMName'
        caching: 'ReadWrite'
        createOption: 'FromImage'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: 'id'
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
        storageUri:  'storageUri'
      }
    }
  }
}


