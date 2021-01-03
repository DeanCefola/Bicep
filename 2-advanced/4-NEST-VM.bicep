param Prefix string
param adminUserName string
param adminPassword string {
  secure: true
}
param OperatingSystem string
param License object
param vnetId string
param subnetId string
param location string
param vmSize string

var avsetName = '${Prefix}avset1'
var vmName = '${Prefix}vm1'
var nicName = '${Prefix}nic1'

resource avset1 'Microsoft.Compute/availabilitySets@2020-06-01' = {
  name: avsetName
  location:location
  properties:{
    platformFaultDomainCount: 5
    platformUpdateDomainCount: 2
  }  
}
resource nic1 'Microsoft.Network/networkInterfaces@2020-06-01' = {
  name: nicName
  location:location
  properties:{
    ipConfigurations:[
      {
        name: 'ipconfig1'
        properties:{
           primary:true
           privateIPAllocationMethod:'Dynamic'
           subnet:{
             id:subnetId
           }
        }
      }
    ]
  }
}
resource vm1 'Microsoft.Compute/virtualMachines@2020-06-01' = {
  name:vmName
  location:location
  properties:{
    availabilitySet:{
      id:avset1.id
    }
    hardwareProfile:{
      vmSize:'Standard_B2ms'
    }
    osProfile:{
      adminUsername: adminUserName
      adminPassword:adminPassword
      computerName:vmName
      windowsConfiguration:{
        provisionVMAgent:true
      }      
    }
    networkProfile:{
      networkInterfaces:[
        {
          id:nic1.id
          properties:{
            primary:true            
          }          
        }
      ]
    }
    storageProfile:{
      osDisk:{
        name: '${vmName}-osDisk'
        caching: 'ReadWrite'
        createOption:'FromImage'
        managedDisk:{
          storageAccountType:'StandardSSD_LRS'
        }
        osType:'Windows'        
      }
      imageReference:{
        publisher:OperatingSystem
        offer:OperatingSystem
        sku:OperatingSystem
        version:OperatingSystem
      }
    }
  }
  dependsOn:[
    avset1
    nic1
  ]
}