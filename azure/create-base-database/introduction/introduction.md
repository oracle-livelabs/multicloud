# Introduction

Oracle Database@Azure is a managed Oracle Database service that runs Oracle Cloud Infrastructure (OCI)–managed Oracle databases colocated inside Microsoft Azure data centers, giving Azure applications low-latency access to Oracle Database services while billing and management are integrated through Azure.

Oracle Base Database Service is a fully managed cloud solution that enables organizations to quickly deploy, manage, and scale Oracle databases in the cloud. It provides automated provisioning, patching, backups, and monitoring, freeing users from administrative overhead and allowing them to focus on application development and innovation. The service is designed for high performance, security, and seamless integration with other Cloud services, making it an ideal choice for both transactional and analytical workloads.

## About this Workshop
In this workshop, you learn how to create a resource group, a virtual network, a private subnet to the virtual network and delegate the subnet to the Oracle Database@Azure Service. You will also create a public subnet that you will use when you create the virtual machine. Before you can create the Oracle Base Database Service, you need to create a Resource Anchor and a Network Anchor. Next, you'll create the Oracle Base Database Service. Finally, you will create a Windows virtual machine in order to connect to SQL Developer and then run a simple SQL query.

Estimated Workshop Time: 1 hour 55 minutes

### Objectives
In this workshop, you will create the following in Azure Portal:

* Create a resource group
* Create a virtual network (VNet) in the resource group
* Add a subnet to the VNet and delegate the subnet to Oracle Database@Azure Service
* Add a public subnet to the VNet to access the database from the virtual machine
* Create a Resource Anchor
* Create a Network Anchor
* Create an Oracle Base Database Service and review the database in OCI
* Deploy a virtual machine (VM)
* Connect to the Oracle Base Database Service using SQL Developer on the VM and run a simple SQL query

### Prerequisites
- Access to Microsoft Azure portal, OCI tenancy, OCI console, and Oracle Database@Azure.
- An existing Azure subscription. Your Azure subscription must be onboarded and linked to an Oracle Cloud Infrastructure (OCI) tenancy.
- An Oracle Cloud Infrastructure (OCI) account with permissions to view and manage Autonomous AI Database resources within the OCI console.

    >**Note:** If you do not have an Oracle Cloud Infrastructure (OCI) account, you can create one during your service deployment. If you do have an OCI account, you can use it with Oracle Database@Azure.

For detailed information about the prerequisites required to begin onboarding with `Oracle Database@Azure` and to create Base Database on `Oracle Database@Azure`, see [Prerequisites](https://docs.oracle.com/en-us/iaas/Content/database-at-azure/oaaprerequisites.htm).

You may now proceed to the next lab.

## Learn More
* [Oracle Database@Azure](https://docs.oracle.com/en-us/iaas/Content/database-at-azure/oaa.htm)
* [Onboarding with Oracle Database@Azure](https://docs.oracle.com/en-us/iaas/Content/multicloud/oaaonboard.htm)
* [Oracle Base Database](https://docs.oracle.com/en-us/iaas/Content/database-at-azure/azucr-create-base-database.html)

## Acknowledgements
- **Author:** Lauran K. Serhal, Consulting User Assistance Developer, Oracle Autonomous AI Database and Multicloud
- **Contributor:** Devinder Singh, Senior Principal Solutions Architect - Multicloud
- **Last Updated By/Date:** Lauran K. Serhal, March 2026
