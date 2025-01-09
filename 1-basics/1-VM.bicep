// Parameters //
@secure()
param AdminPassword string

@allowed([
  'Small'
  'Medium'
  'Large'
])
param VMSize string = 'Small'
// Parameters //

// Variables //
var VM_SIZES = {
  Small: {
    WVDsize: 'Standard_B2ms'
  }
  Medium: {
    WVDsize: 'Standard_DS3_v2'
  }
  Large: {
    WVDsize: 'Standard_DS14_v2'
  }
}
// Variables //

// Resources //
resource windowsVM1storage 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: toLower('windowsVM1storage')
  location: resourceGroup().location
  tags: {
    displayName: 'windowsVM1 Storage Account'
  }
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'Storage'
}

resource windowsVM1_PublicIP 'Microsoft.Network/publicIPAddresses@2023-04-01' = {
  name: 'windowsVM1-PublicIP'
  location: resourceGroup().location
  tags: {
    displayName: 'PublicIPAddress'
  }
  properties: {
    publicIPAllocationMethod: 'Dynamic'
    dnsSettings: {
      domainNameLabel: toLower('windowsVM1')
    }
  }
}

resource windowsVM1_nsg 'Microsoft.Network/networkSecurityGroups@2023-04-01' = {
  name: 'windowsVM1-nsg'
  location: resourceGroup().location
  properties: {
    securityRules: [
      {
        name: 'nsgRule1'
        properties: {
          description: 'description'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
        }
      }
    ]
  }
}

resource windowsVM1_VirtualNetwork 'Microsoft.Network/virtualNetworks@2023-04-01' = {
  name: 'windowsVM1-VirtualNetwork'
  location: resourceGroup().location
  tags: {
    displayName: 'windowsVM1-VirtualNetwork'
  }
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'windowsVM1-VirtualNetwork-Subnet'
        properties: {
          addressPrefix: '10.0.0.0/24'
          networkSecurityGroup: {
            id: windowsVM1_nsg.id
          }
        }
      }
    ]
  }
}

resource windowsVM1_NetworkInterface 'Microsoft.Network/networkInterfaces@2023-04-01' = {
  name: 'windowsVM1-NetworkInterface'
  location: resourceGroup().location
  tags: {
    displayName: 'windowsVM1 Network Interface'
  }
  properties: {
    ipConfigurations: [
      {
        name: 'ipConfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: windowsVM1_PublicIP.id
          }
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', 'windowsVM1-VirtualNetwork', 'windowsVM1-VirtualNetwork-Subnet')
          }
        }
      }
    ]
  }
  dependsOn: [

    windowsVM1_VirtualNetwork
  ]
}

resource windowsVM1 'Microsoft.Compute/virtualMachines@2023-03-01' = {
  name: 'VMName'
  location: resourceGroup().location
  tags: {
    displayName: 'windowsVM1'
  }
  properties: {
    hardwareProfile: {
      vmSize: VM_SIZES[VMSize].WVDsize
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
        name: 'windowsVM1OSDisk'
        caching: 'ReadWrite'
        createOption: 'FromImage'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: windowsVM1_NetworkInterface.id
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
        storageUri: windowsVM1storage.properties.primaryEndpoints.blob
      }
    }
  }
}
// Resources //
