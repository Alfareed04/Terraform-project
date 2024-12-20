resource_name = "Project3-rg"
location      = "East US"

vnet = {
  project3_vnet = {
    name          = "project3_vnet"
    address_space = ["10.2.0.0/16"]
    subnets = {
      subnet1 = {
        subnet_name    = "subnet1"
        address_prefix = ["10.2.1.0/24"]
      },
      subnet2 = {
        subnet_name    = "subnet2"
        address_prefix = ["10.2.2.0/24"]
      },
      subnet3 = {
        subnet_name    = "subnet3"
        address_prefix = ["10.2.3.0/24"]
      },
      subnet4 = {
        subnet_name    = "subnet4"
        address_prefix = ["10.2.4.0/24"]
      }
    }
  }
}

nsg = {
  "nsg-1" = {
    nsg_name = "nsg-1"
  },
  "nsg-2" = {
    nsg_name = "nsg-2"
  },
  "nsg-3" = {
    nsg_name = "nsg-3"
  },
  "nsg-4" = {
    nsg_name = "nsg-4"
  },
}

nsg_config = {
  "nsg-1" = {
    nsg_name = "nsg-1"
    security_rules = [
      {
        name                       = "allow_port"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_ranges    = ["22", "80", "443"]
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      }
    ]
  },
  "nsg-2" = {
    nsg_name = "nsg-2"
    security_rules = [
      {
        name                       = "allow_port"
        priority                   = 101
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_ranges    = ["22", "80", "443"]
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      }
    ]
  },
  "nsg-3" = {
    nsg_name = "nsg-3"
    security_rules = [
      {
        name                       = "allow_port"
        priority                   = 102
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_ranges    = ["22", "80", "443"]
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      }
    ]
  },
  "nsg-4" = {
    nsg_name = "nsg-4"
    security_rules = [
      {
        name                       = "allow_port"
        priority                   = 103
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_ranges    = ["22", "80", "443"]
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      }
    ]
  }
}

subnet-to-nsg-associate = {
  "nsg-1" = {
    subnet_id = "subnet1"
  },
  "nsg-2" = {
    subnet_id = "subnet2"
  },
  "nsg-3" = {
    subnet_id = "subnet3"
  },
  "nsg-4" = {
    subnet_id = "subnet4"
  }
}

route_tables = {
  "route1" = {
    route_table_name = "route1"
  },
  "route2" = {
    route_table_name = "route2"
  },
  "route3" = {
    route_table_name = "route3"
  },
  "route4" = {
    route_table_name = "route4"
  }
}

subnet-to-route-associate = {
  "route1" = {
    subnet_id = "subnet1"
  },
  "route2" = {
    subnet_id = "subnet2"
  },
  "route3" = {
    subnet_id = "subnet3"
  },
  "route4" = {
    subnet_id = "subnet4"
  }
}

