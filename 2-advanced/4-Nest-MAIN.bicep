param Prefix string
param adminUserName string = 'lntad'
param adminPassword string {
  secure: true
}
param vnetIPs string {
   default: '10.0.0.0/8'
   allowed:[
    '10.0.0.0/8'
    '10.1.0.0/8'
    '172.18.0.0/16'
    '172.19.0.0/16'
    '192.168.0.0/24'
    '192.168.1.0/24'
   ]
}
param VMSize string {
  default: 'Small'
  allowed:[
    'Small'
    'Medium'
    'Large'
  ]
}
param OperatingSystem string {
  default: 'Client'
  allowed:[
    'Client'
    'Server'
  ]
}


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
    Publisher:'microsoftwindowsdesktop'
    offer: 'office-365'
    sku: '20h1-evd-o365pp'
    version: 'latest'
    }
  Server: {
    Publisher:'MicrosoftWindowsServer'
    offer: 'WindowsServer'
    sku: '2019-Datacenter-smalldisk'
    version: 'latest'
    }  
}
var License = {
  Server:{
    License: 'Windows_Server'
  }
  Client: {
    License: 'Windows_Client' 
  }
}


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
    vmSize:vmHWSize[VMSize].value
    OperatingSystem: VM_Images[OperatingSystem]
    License: License[OperatingSystem].License

  }
  dependsOn:[
    VNET
  ]
}
