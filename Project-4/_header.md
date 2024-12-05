### Use Level 03 as Data Block and Create Additional Resources

#### Project Overview: Terraform Automation for Azure Infrastructure
This Terraform configuration automates the creation and management of Azure infrastructure for a Project 3 environment. It incorporates modular design principles for reusability, scalability, and efficient resource provisioning. Below is a concise summary of the components:

<b>Resource Group:</b> 

Utilizes existing resource group (Project3-rg) to organize resources logically.

<b>Networking:</b>

Virtual Network (project3_vnet) is fetched and referenced.

Subnets are created dynamically using a reusable module.

<b>Key Vault:</b>

Configures a Key Vault with access policies, encryption keys, and secrets for secure storage of credentials and sensitive data.

Supports soft-delete and purge protection for compliance and recovery.

<b>Disk Management:</b>

Creates managed disks and encrypts them using Key Vault encryption keys.

Allows for VM attachment and storage customization.

<b>Load Balancing:</b>

Sets up a Standard Load Balancer with frontend IP, backend pool, health probe, and load balancing rules.

Associates network interfaces with backend pools for efficient traffic management.

<b>Storage Account:</b>

Creates a Standard LRS storage account for durable, redundant storage needs.

<b>Networking Interfaces:</b>

Deploys Network Interfaces (NICs) with dynamic IP allocation and integrates them with subnets and load balancer backend pools.

<b>Virtual Machine:</b>

Prepares a module for provisioning VMs with encryption-enabled disks, secure login credentials, and optimal sizing for workloads.

#### Key Features:
<b>Modular Design:</b> Ensures code reusability across multiple projects.
<b>Scalability:</b> Easily extendable for future enhancements.
<b>Security:</b> Implements Azure Key Vault and encryption to secure sensitive data.
<b>Automation:</b> Reduces manual effort, ensuring consistent and reliable deployments.