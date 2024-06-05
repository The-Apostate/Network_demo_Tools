param location string
param gatewayName string
param virtualNetworkName string
param subnetName string = 'GatewaySubnet'
param publicIpName string
param skuName string = 'VpnGw1' // Valid SKU for RouteBased VpnType

// Create the Public IP addresses for the ExpressRoute Gateway
resource publicIp1 'Microsoft.Network/publicIPAddresses@2021-02-01' = {
  name: '${publicIpName}-1'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
  }
}

resource publicIp2 'Microsoft.Network/publicIPAddresses@2021-02-01' = {
  name: '${publicIpName}-2'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
  }
}

// Create the ExpressRoute Gateway
resource expressRouteGateway 'Microsoft.Network/virtualNetworkGateways@2021-02-01' = {
  name: gatewayName
  location: location
  properties: {
    sku: {
      name: skuName
      tier: skuName // Use the same value for tier
    }
    gatewayType: 'Vpn' // Must be 'Vpn' for VpnType 'RouteBased'
    vpnType: 'RouteBased' // Valid for RouteBased
    enableBgp: false
    activeActive: true
    ipConfigurations: [
      {
        name: 'gwipconfig1'
        properties: {
          publicIPAddress: {
            id: publicIp1.id
          }
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', virtualNetworkName, subnetName)
          }
        }
      }
      {
        name: 'gwipconfig2'
        properties: {
          publicIPAddress: {
            id: publicIp2.id
          }
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', virtualNetworkName, subnetName)
          }
        }
      }
    ]
  }
}
