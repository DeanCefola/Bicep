param Prefix string
param adminUserName string
param adminPassword string {
  secure: true
}
param OperatingSystem object
param License string
param subnetId string
param vmSize string
var avsetName = '${Prefix}avset1'
var vmName = '${Prefix}vm1'
var nicName = '${Prefix}nic1'
resource avset1 'Microsoft.Compute/availabilitySets@2019-07-01' = {
  name: avsetName
  location:resourceGroup().location
  properties:{
    platformFaultDomainCount: 3
    platformUpdateDomainCount: 2
  }
  sku:{
    name: 'Aligned'
  }   
}
resource nic1 'Microsoft.Network/networkInterfaces@2020-06-01' = {
  name: nicName
  location:resourceGroup().location
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
  dependsOn:[
    avset1
  ]
}
resource vm1 'Microsoft.Compute/virtualMachines@2020-06-01' = {
  name:vmName
  location:resourceGroup().location
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
        publisher:OperatingSystem.publisher
        offer:OperatingSystem.offer
        sku:OperatingSystem.sku
        version:OperatingSystem.version
      }
    }
    licenseType: License
  }
  dependsOn:[
    avset1
    nic1
  ]
}