targetScope = 'subscription'

resource rg1 'Microsoft.Resources/resourceGroups@2019-03-01' = {
  location: 'eastus'
  name: 'testBicep'  
}
