param location string
param hubName string
param hubAddressSpace string
param hubSubnets array
param spokes array

// Create the hub virtual network
resource hubVnet 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: hubName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        hubAddressSpace
      ]
    }
    subnets: [
      for subnet in hubSubnets: {
        name: subnet.name
        properties: {
          addressPrefix: subnet.cidr
        }
      }
    ]
  }
}

// Create the spoke virtual networks
resource spokeVnets 'Microsoft.Network/virtualNetworks@2021-02-01' = [for spoke in spokes: {
  name: spoke.name
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        spoke.addressSpace
      ]
    }
    subnets: [
      for subnet in spoke.subnets: {
        name: subnet.name
        properties: {
          addressPrefix: subnet.cidr
        }
      }
    ]
  }
}]

// Create virtual network peerings from hub to spokes
resource vnetPeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2021-02-01' = [
  for (spoke, i) in spokes: {
    name: '${hubName}-to-${spoke.name}'
    parent: hubVnet
    properties: {
      allowVirtualNetworkAccess: true
      remoteVirtualNetwork: {
        id: resourceId('Microsoft.Network/virtualNetworks', spoke.name)
      }
    }
  }
]

// Create virtual network peerings from spokes to hub
resource vnetPeering2 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2021-02-01' = [
  for (spoke, i) in spokes: {
    name: '${spoke.name}-to-${hubName}'
    parent: spokeVnets[i]
    properties: {
      allowVirtualNetworkAccess: true
      remoteVirtualNetwork: {
        id: hubVnet.id
      }
    }
  }
]
