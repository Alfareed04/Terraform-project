resource_group_name = "Project1_rg"
resource_group_location = "East US"

vnets={
    "project1_vnet" ={
        vnet_name="project1_vnet"
        address_space="10.0.0.0/16"
    }
}

subnets={
    "SubnetWpp" ={
        subnet_name ="SubnetWpp"
        address_prefix = "10.0.1.0/24"
    },
    "SubnetApp" ={
        subnet_name = "SubnetApp"
        address_prefix = "10.0.2.0/24"
    }
    "SubnetLB" = {
      subnet_name = "SubnetLB"
      address_prefix = "10.0.3.0/24"
    }
    "SubnetAPPGW" = {
      subnet_name = "SubnetAPPGW"
      address_prefix = "10.0.4.0/24"
    }
}
