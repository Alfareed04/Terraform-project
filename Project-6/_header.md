## Use Level 03, 04, and 05 as Data Block (Azure Firewall, Route Outbound Traffic)

### Project Overview: Azure Firewall and Networking Deployment
This project involves setting up a secure Azure network infrastructure, including resources like Azure Firewall, Route Tables, NSGs, and their associations. Below is a step-by-step outline:

#### 1. Resource Group
Use data block to retrieve the existing resource group Project3-rg.

#### 2. Virtual Network (VNet)
Retrieve details of an existing VNet project3_vnet in the resource group.

#### 3. Subnet Configuration
Existing Subnets: Retrieve existing subnets using a for_each loop for multiple subnets.
New Subnet: Provision a new subnet for Azure Firewall using the firewall_subnet module.

#### 4. Firewall Public IP
Create a static public IP with the "Standard" SKU for Azure Firewall.

#### 5. Firewall Policy
Deploy a "Standard" SKU firewall policy for centralized management.

#### 6. Azure Firewall
Deploy the Azure Firewall with:
SKU: Standard
Subnet: AzureFirewallSubnet
Public IP association.
Link the firewall policy.

#### 7. Route Table and Routes
Create a route table.
Add a default route to direct traffic through the firewall using the VirtualAppliance next hop.

#### 8. Route Table Association
Associate the created route table with the specific subnet.

#### 9. Network Security Groups (NSG)
Deploy an NSG for traffic filtering.
Add rules dynamically using a for_each loop for multiple security rules.

#### 10. NSG Association
Link the NSG to a specific subnet.