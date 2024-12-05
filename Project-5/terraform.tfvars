subnets = {
  "subnet01" = {
    subnet_name = "subnet01"
    address_prefix = "10.2.5.0/24"
  },
  "subnet02" = {
    subnet_name = "subnet02"
    address_prefix = "10.2.6.0/24"
  }
}

appgw-subnet = {
  "AppGw" = {
    subnet_name = "AppGw"
    address_prefix = "10.2.7.0/24"
  }
}

dns_name = "dnszone.privateendpoint"
dns_link_name = "dns-zone-link"
dns_record_name = "dns-records"
user_assigned_identity_name = "key-identity"