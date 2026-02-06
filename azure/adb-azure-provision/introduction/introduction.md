# Introduction
`Oracle Database@Azure` is a cloud database service that enables you to access OCI managed Oracle Exadata infrastructure inside Azure data centers.

Oracle Autonomous AI Database available under `Oracle Database@Azure` is a fully automated database service that makes it easy for all organizations to develop and deploy application workloads, regardless of complexity, scale, or criticality. It is the only database cloud service that meets the needs ranging from self-service analytics to sophisticated, large-scale data management applications. Autonomous AI Database supports multiple workloads, including: AI Lakehouse, AI Transaction Processing, JSON-centric Applications, and Oracle APEX Low Code Development. Some of the key benefits include the following features:
- Low Latency: By running Oracle databases in the same data centers as Azure applications, the service provides high performance and low-latency connectivity, crucial for mission-critical workloads.
- Unified Management: Customers can provision, manage, and monitor the Oracle Autonomous Database directly from the Azure portal using familiar Azure APIs, CLIs, and SDKs.
- Automatic Management: As an "Autonomous" service, Oracle handles routine administrative tasks such as provisioning, tuning, patching, backups, and scaling automatically, reducing operational overhead.
- Integrated Monitoring: Database metrics, audit logs, and events are natively available within Azure Monitor for a unified monitoring experience.

# About this Workshop
In this workshop, you learn how to create a resource principal, a virtual network, add a subnet to the virtual network, and and delegate the subnet to the `Oracle Database@Azure Service`. Next, you provision an Oracle Autonomous AI Database using those resources in `Oracle Database@Azure`.

Estimated Time: 20 minutes

### Objectives
In this workshop, you will:

* Create a resource group in Azure Portal
* Create a virtual network (VNet) in Azure Portal
* Add a subnet to the virtual network and delegate the subnet to `Oracle Database@Azure Service`
* Provision an Oracle Autonomous AI Database in `Oracle Database@Azure`
* Review the provisioned Oracle Autonomous AI Database in OCI
* Deploy a Virtual Machine (VM) to access the Database actions

### Prerequisites
- An existing Azure subscription
- An Oracle Cloud Infrastructure (OCI) account
    >**Note:** If you do not have an Oracle Cloud Infrastructure (OCI) account, you can create one during your service deployment. If you do have an OCI account, you can use it with `Oracle Database@Azure`.

- Access to Microsoft Azure cloud, OCI tenancy, and `Oracle Database@Azure`.

    For detailed information about the prerequisites required to begin onboarding with `Oracle Database@Azure`, see [Prerequisites](https://docs.oracle.com/en-us/iaas/Content/database-at-azure/oaaprerequisites.htm).

Find more details on getting started [Onboarding with Oracle Database@Azure](https://docs.oracle.com/en-us/iaas/Content/multicloud/oaaonboard.htm)

Please proceed to the next lab.

## Learn More
* [Oracle Database@Azure](https://docs.oracle.com/en-us/iaas/Content/database-at-azure/oaa.htm)

## Acknowledgements
* **Author:** Lauran K. Serhal, Consulting User Assistance Developer, Oracle Autonomous AI Database and Multicloud
* **Contributors:**
    * Devinder Singh, SR Principal Solutions Architect - Multicloud
    * Tejus Subrahmanya, Principal Product Manager
* **Last Updated By/Date:** Lauran K. Serhal, February 2026
