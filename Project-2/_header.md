### Create Modules for Resource Providers

#### Project Overview:
The project leverages Terraform to create an Azure environment with a set of essential network resources. It involves the automation of resource group creation, virtual network (VNet) setup, subnets, network security groups (NSG), and route tables.

#### Key Components:
<b>Resource Group:</b> The project begins by defining a Resource Group using the azurerm provider. This is the logical container for all other Azure resources.

<b>Virtual Network (VNet):</b> Multiple VNets are created based on input variables, with each VNet having its own address space and location. Dependencies ensure they are created after the Resource Group.

<b>Subnets:</b> Subnets are defined within the VNets, with specific address prefixes, ensuring proper network segmentation.

<b>Network Security Group (NSG):</b> NSGs are set up to define rules for network traffic flow to protect resources within the VNets.

<b>NSG Rules:</b> Custom rules for the NSGs are created based on the configuration, defining traffic flow and security posture.

<b>Route Tables:</b> Route tables are configured to define the network routes for traffic between subnets and VNets.

#### Modules Used:

<b> Resource Group Module:</b> Responsible for resource group creation.

<b>VNet Module:</b> Sets up the virtual network with configurable address spaces.

<b>Subnet Module:</b> Creates subnets with specific IP address ranges.

<b>NSG Module:</b> Defines security group for controlling inbound and outbound traffic.

<b>NSG Rule Module:</b> Sets specific rules for network traffic control.

<b>Route Table Module:</b> Configures routing for the subnets.

### Conclusion:

This Terraform-based project automates the process of setting up a secure, scalable network architecture on Azure, streamlining the deployment of VNets, subnets, security groups, and routing tables. The use of modules enhances reusability and maintainability, making it easier to manage the resources as the project grows.

## Architecture Diagram
![Project-2](https://github.com/user-attachments/assets/b963ba05-f7cb-41a6-a0b7-511405c76d19)

## Run the Terraform configurations :
Deploy the resources using Terraform,
```
terraform init
```
```
terraform plan
```
```
terraform apply
```
