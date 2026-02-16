# Introduction

`Oracle Database@Azure` is a managed Oracle Database service that runs Oracle Cloud Infrastructure (OCI)–managed Oracle databases colocated inside Microsoft Azure data centers, giving Azure applications low-latency access to Oracle Database services while billing and management are integrated through Azure.

Oracle Autonomous AI Database available under `Oracle Database@Azure` is a fully automated database service that makes it easy for all organizations to develop and deploy application workloads, regardless of complexity, scale, or criticality. It is the only database cloud service that meets the needs ranging from self-service analytics to sophisticated, large-scale data management applications. Autonomous AI Database supports multiple workloads, including: AI Lakehouse, AI Transaction Processing, JSON-centric Applications, and Oracle APEX Low Code Development. Some of the key benefits include the following features:
- Low Latency: By running Oracle databases in the same data centers as Azure applications, the service provides high performance and low-latency connectivity, crucial for mission-critical workloads.
- Unified Management: Customers can create, manage, and monitor the Oracle Autonomous AI Database directly from the Azure portal using familiar Azure APIs, CLIs, and SDKs.
- Automatic Management: As an "Autonomous" service, Oracle handles routine administrative tasks such as creating, tuning, patching, backups, and scaling automatically, reducing operational overhead.
- Integrated Monitoring: Database metrics, audit logs, and events are natively available within Azure Monitor for a unified monitoring experience.

# About this Workshop
In this workshop, you learn how to create a resource group, a virtual network, add a private subnet to the virtual network and delegate the subnet to the `Oracle Database@Azure Service`. You will also add a public subnet. Next, you create an Oracle Autonomous AI Database using those resources in `Oracle Database@Azure`. Finally, you deploy a virtual machine using the public subnet and in order to access Database actions in the created database and then run a simple SQL query.

Estimated Time: 45 minutes

### Objectives
In this workshop, you will:

* Create a resource group in Azure Portal
* Create a virtual network (VNet) in Azure Portal
* Add a subnet to the VNet and delegate the subnet to `Oracle Database@Azure Service`
* Add a public subnet to the VNet to access the database from the virtual machine
* Create an Oracle Autonomous AI Database in `Oracle Database@Azure`
* Review the created Oracle Autonomous AI Database in OCI
* Deploy a virtual machine (VM) to access the Database actions

### Prerequisites
- Access to Microsoft Azure portal, OCI tenancy, OCI console, and `Oracle Database@Azure`.
- An existing Azure subscription. Your Azure subscription must be onboarded and linked to an Oracle Cloud Infrastructure (OCI) tenancy.
- An Oracle Cloud Infrastructure (OCI) account with permissions to view and manage Autonomous AI Database resources within the OCI console.

    >**Note:** If you do not have an Oracle Cloud Infrastructure (OCI) account, you can create one during your service deployment. If you do have an OCI account, you can use it with `Oracle Database@Azure`.

For detailed information about the prerequisites required to begin onboarding with `Oracle Database@Azure`, see [Prerequisites](https://docs.oracle.com/en-us/iaas/Content/database-at-azure/oaaprerequisites.htm).

You may now proceed to the next lab.

## Learn More
* [Oracle Database@Azure](https://docs.oracle.com/en-us/iaas/Content/database-at-azure/oaa.htm)
* [Onboarding with Oracle Database@Azure](https://docs.oracle.com/en-us/iaas/Content/multicloud/oaaonboard.htm)

## Acknowledgements
- **Author:** Lauran K. Serhal, Consulting User Assistance Developer, Oracle Autonomous AI Database and Multicloud
- **Contributor:** Devinder Singh, SR Principal Solutions Architect - Multicloud
- **Last Updated By/Date:** Lauran K. Serhal, February 2026
