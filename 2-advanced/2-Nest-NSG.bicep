param Prefix string
var nsgName = '${Prefix}NsgName01'
resource nsg1 'Microsoft.Network/networkSecurityGroups@2020-06-01' = {
  location:resourceGroup().location
  name: nsgName
}
output nsg1Id string = nsg1.id  