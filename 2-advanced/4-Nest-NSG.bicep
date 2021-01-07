param Prefix string
param name string
param location string
resource nsg1 'Microsoft.Network/networkSecurityGroups@2020-06-01' = {
  location:location
  name: name
}
output nsg1Id string = nsg1.id  