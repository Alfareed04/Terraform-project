subnets = {
  "subnet01" = {
    subnet_name    = "subnet01"
    address_prefix = "10.2.5.0/24"
  },
  "subnet02" = {
    subnet_name    = "subnet02"
    address_prefix = "10.2.6.0/24"
  }
}

firewall-subnet = {
  "AzureFirewallSubnet" = {
    subnet_name    = "AzureFirewallSubnet"
    address_prefix = "10.2.8.0/24"
  }
}

nsg_name = "firewall-nsg"

nsg_config = {
  "firewall-nsg" = {
    nsg_name = "firewall-nsg"
    security_rules = [
      {
        name                       = "allow_port"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_ranges    = ["22", "80", "443", "3389"]
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      }
    ]
  }
}
route_table_name = "firewall-routetable"
