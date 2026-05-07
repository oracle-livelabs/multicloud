# Introduction

Oracle AI Database@AWS is a managed Oracle Database service that runs Oracle Cloud Infrastructure (OCI)–managed Oracle databases colocated inside AWS  data centers, giving AWS  applications low-latency access to Oracle Database services while billing and management are integrated through AWS.

Oracle Exadata on Oracle AI Database@AWS is Oracle’s high-performance database platform delivered natively inside AWS data centers as part of its multicloud offering. It brings the full power of Exadata—Oracle’s engineered system optimized for database workloads—closer to applications running on AWS.

Exadata on Oracle AI Database@AWS lets you run Oracle databases on dedicated Exadata infrastructure physically located in AWS, but managed using Oracle Cloud Infrastructure (OCI) services.

**Key points:**

Engineered for performance: Combines specialized compute, storage, and networking (RDMA, smart storage servers) to accelerate OLTP, analytics, and mixed workloads.

Low-latency integration with AWS apps: Since Exadata is co-located in AWS regions, applications (e.g., on EC2/EKS) can access databases with single-digit millisecond latency over private networking.

OCI-managed experience: You use OCI tools/APIs for provisioning, scaling, patching, and backups, even though the hardware sits in AWS.

Private, secure connectivity: Integrated via ODB networking and peering—no public internet exposure.

Full Oracle Database feature set: Supports RAC, Data Guard, Autonomous capabilities, and Exadata-specific optimizations.

Why it matters:
It removes the traditional trade-off between running apps in AWS and databases in OCI—giving you best-in-class Oracle database performance with tight integration into AWS-native architectures.

## About this Workshop
In this workshop, you learn how to create an ODB Network, Exadata Infrastructure, Exadata VM Cluster and finally an Exadata Database.

Estimated Workshop Time: 6 to 7 hour
 [](youtube:Sp8urQa1HyU)

### Objectives
In this workshop, you will create the following in AWS Console:

* Create an ODB Network
* Create an Exadata Infrastructure
* Create an Exadata VM Cluster

In this workshop, you will create the following in OCI  Console:
* Create an Exadata Database


### Prerequisites
- Access to AWS Console, OCI tenancy, OCI console, and Oracle AI Database@AWS.
- An existing AWS Account. Your AWS account  must be onboarded and linked to an Oracle Cloud Infrastructure (OCI) tenancy.
- An Oracle Cloud Infrastructure (OCI) account with permissions to view and manage resources through the OCI console.

    >**Note:** If you do not have an Oracle Cloud Infrastructure (OCI) account, you can create one during your service deployment. If you do have an OCI account, you can use it with Oracle AI Database@AWS.

For detailed information about the prerequisites required to begin onboarding with `Oracle AI Database@AWS` and to create Base Database on `Oracle AI Database@AWS`, see [Prerequisites](https://docs.oracle.com/en-us/iaas/Content/database-at-aws/oaaws-prerequisites.htm).

You may now proceed to the next lab.

## Learn More
* [Oracle AI Database@AWS](https://docs.oracle.com/en-us/iaas/Content/database-at-aws/oaaws.htm)
* [Onboarding with Oracle AI Database@AWS](https://docs.oracle.com/en-us/iaas/Content/database-at-aws/oaaws-onboard.htm)
* [Oracle Exadata Database on Dedicated Infrastructure](https://docs.oracle.com/en/engineered-systems/exadata-cloud-service/ecscm/exadata-cloud-infrastructure-overview.html)

## Acknowledgements
- **Author:** Devinder Singh, Senior Principal Solutions Architect - Multicloud
- **Contributor:** Devinder Singh, Senior Principal Solutions Architect - Multicloud
- **Last Updated By/Date:** Devinder Singh, May 2026
