### Project 01: Basic Azure Resources Setup (VNET, Subnet, Resource Group, NSG, Route Table)

1. <b>Resource Group:</b> Creates an Azure resource group as a container for the resources.

2. <b>Virtual Network (VNet):</b> Creates multiple virtual networks based on the provided variable vnets, with address spaces and associations to the resource group.

3. <b>Subnets:</b> Creates subnets within a specified VNet using the subnets variable, and associates each with a unique address prefix.

4. <b>Route Table:</b> Creates a route table and associates it with subnets for custom routing.

5. <b>Route Table Association:</b> Associates the created route table with each subnet.

6. <b>Network Security Group (NSG):</b> Creates an NSG with security rules to allow inbound RDP (3389) and HTTP (80) traffic.

7. <b>NSG Association:</b> Associates the NSG with a specified subnet (in this case, "SubnetApp").

