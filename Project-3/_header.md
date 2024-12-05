### Consume Modules to Create (VNET, Subnet, Resource Group, NSG, Route Table)

#### Project Overview:

This project uses Terraform to automate the creation and configuration of a secure and scalable network architecture on Microsoft Azure. By utilizing modular Terraform design, the project ensures a reusable, organized, and efficient infrastructure setup.

#### Key Components:

##### Resource Group (RG):
Creates a logical container for Azure resources to manage and organize them effectively.

##### Virtual Network (VNet):
Provisions multiple VNets, each with configurable address spaces and linked to the Resource Group.

##### Subnets:
Configures network segmentation by defining subnets within VNets, ensuring proper isolation and address allocation.

##### Network Security Groups (NSG):
Establishes security boundaries by creating NSGs for controlling inbound and outbound traffic.

##### NSG Rules:
Implements granular traffic control by defining custom security rules for each NSG.

##### NSG-to-Subnet Association:
Associates NSGs with specific subnets to enforce traffic control policies.

##### Route Tables:
Configures custom routing rules to manage traffic flow within and across subnets.

##### Route Table-to-Subnet Association:
Links route tables to subnets, enabling optimized traffic routing.

#### Highlights:

<b>Modular Design:</b> Reusable modules for Resource Groups, VNets, Subnets, NSGs, and Route Tables.

<b>Scalable Infrastructure:</b> Supports dynamic provisioning using variables and for_each.

<b>Security Focused:</b> Granular NSG rules and route configurations for controlled access and traffic management.