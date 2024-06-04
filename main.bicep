targetScope = 'resourceGroup'

// Define parameters for locations and other settings
param location string = 'uksouth'

// Deploy the network module for UK South
module networkSouth 'NetworkModule.bicep' = {
  name: 'networkSouthDeployment'
  params: {
    location: location
    hubName: 'vnet_south_hub'
    hubAddressSpace: '10.0.0.0/16'
    hubSubnets: [
      { name: 'AzureFirewallSubnet', cidr: '10.0.0.0/27' }
      { name: 'AzureBastionSubnet', cidr: '10.0.0.32/27' }
      { name: 'Security', cidr: '10.0.1.0/24' }
      { name: 'GatewaySubnet', cidr: '10.0.255.0/27' }
    ]
    spokes: [
      {
        name: 'vnet_south_spoke1'
        addressSpace: '10.1.0.0/16'
        subnets: [
          { name: 'Virtual_Machines', cidr: '10.1.0.0/24' }
          { name: 'south_subnet1', cidr: '10.1.1.0/24' }
          { name: 'Data', cidr: '10.1.2.0/24' }
        ]
      }
      {
        name: 'vnet_south_spoke2'
        addressSpace: '10.2.0.0/16'
        subnets: [
          { name: 'Virtual_Machines', cidr: '10.2.0.0/24' }
          { name: 'south_subnet2', cidr: '10.2.1.0/24' }
          { name: 'Data', cidr: '10.2.2.0/24' }
        ]
      }
    ]
  }
}

// Deploy the network module for UK West
module networkWest 'NetworkModule.bicep' = {
  name: 'networkWestDeployment'
  params: {
    location: 'ukwest'
    hubName: 'vnet_west_hub'
    hubAddressSpace: '172.16.0.0/16'
    hubSubnets: [
      { name: 'AzureFirewallSubnet', cidr: '172.16.0.0/27' }
      { name: 'AzureBastionSubnet', cidr: '172.16.0.32/27' }
      { name: 'Security', cidr: '172.16.1.0/24' }
      { name: 'GatewaySubnet', cidr: '172.16.255.0/27' }
    ]
    spokes: [
      {
        name: 'vnet_west_spoke1'
        addressSpace: '172.17.0.0/16'
        subnets: [
          { name: 'Virtual_Machines', cidr: '172.17.0.0/24' }
          { name: 'west_subnet1', cidr: '172.17.1.0/24' }
          { name: 'Data', cidr: '172.17.2.0/24' }
        ]
      }
      {
        name: 'vnet_west_spoke2'
        addressSpace: '172.18.0.0/16'
        subnets: [
          { name: 'Virtual_Machines', cidr: '172.18.0.0/24' }
          { name: 'west_subnet2', cidr: '172.18.1.0/24' }
          { name: 'Data', cidr: '172.18.2.0/24' }
        ]
      }
    ]
  }
}

// Deploy the ExpressRoute Gateway for UK South
module expressRouteGatewaySouth 'ExpressRouteGatewayModule.bicep' = {
  name: 'expressRouteGatewaySouthDeployment'
  params: {
    location: location
    gatewayName: 'erGatewaySouth'
    virtualNetworkName: 'vnet_south_hub'
    publicIpName: 'erGatewaySouthPublicIP'
    skuName: 'Standard'
  }
}
