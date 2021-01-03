param Prefix string
param adminUserName string = 'lntad'
param adminPassword string {
  secure: true
}
param vnetIPs array = [
  '10.0.0.0/8'
  '10.1.0.0/8'
  '172.18.0.0/16'
  '172.19.0.0/16'
  '192.168.0.0/24'
  '192.168.1.0/24'
]
param VMSize array = [
  'Small'
  'Medium'
  'Large'
]
param OperatingSystem string = 'Client'

var vnetName = '${Prefix}vnet1' 
var nsgName = '${Prefix}nsg1'
var vmName = '${Prefix}vm1'
var vmHWSize = {  
  Small: {      
    value: 'Standard_B2ms'
  }
  Medium: {        
    value: 'Standard_DS3_v2'
  }
  Large: {        
    value: 'Standard_DS14_v2'
  }  
}
var VM_Images = {
  Client: {
    Publisher:{
      name: 'publisher'
      value: 'microsoftwindowsdesktop'
    }
    offer:{
      name: 'offer'
      value: 'office-365'
    }
    sku:{
      name: 'sku'
      value: '20h1-evd-o365pp'
    }
    version:{
      name: 'version'
      value: 'latest'
    }
  }
  Server: {
    Publisher:{      
      value: 'MicrosoftWindowsServer'
    }
    offer:{      
      value: 'WindowsServer'
    }
    sku:{      
      value: '2019-Datacenter-smalldisk'
    }
    version:{      
      value: 'latest'
    }
  }
  
}
var License = {
  Server:{    
    value: 'Windows_Server'
  }
  Client: {    
    value: 'Windows_Client'
  }
  Multi: {    
    value: 'Windows_Client'
  }
}
var Size = '${vmHWSize}${VMSize}'
var test = VM_Images[OperatingSystem].Publisher

module NSG './4-NEST-NSG.bicep' = {
  name: 'nsg1'
  params:{
    Prefix:Prefix
    name:nsgName
    location: resourceGroup().location
  } 
}
module VNET './4-NEST-VNET.bicep' = {
  name: 'vnet1'
  params:{
    Prefix: Prefix
    location: resourceGroup().location
    vnetName:vnetName
    vnetIPs: vnetIPs    
    vnetSubIPs: '10.0.50.0/24'
    nsg1Id:NSG.outputs.nsg1Id
  } 
  dependsOn: [
    NSG
  ]
}
module VM './4-NEST-VM.bicep' = {
  name: 'vm1'
  params:{
    adminUserName:adminUserName
    adminPassword:adminPassword
    location:resourceGroup().location
    Prefix:Prefix
    vnetId:VNET.outputs.vnetId
    subnetId:VNET.outputs.vnetId
    vmSize:Size
    OperatingSystem: VM_Images.Client.Publisher.value
    License: License.Multi

  }
  dependsOn:[
    VNET
  ]
}