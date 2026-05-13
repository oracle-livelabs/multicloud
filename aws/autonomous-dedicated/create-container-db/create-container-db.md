## Introduction

This lab walks you through creating an **Autonomous Container Database.**

**Oracle Autonomous AI Database** on Oracle AI Database@AWS is Oracle’s fully managed, self-driving database service deployed on dedicated Exadata infrastructure inside AWS data centers. It combines Oracle’s autonomous database automation with the low-latency, native integration of AWS services, enabling enterprises to run mission-critical Oracle workloads close to their AWS applications while minimizing operational overhead.
At the core of the architecture is the **Autonomous Container Database (ACD)**, which acts as the management and resource boundary for multiple Autonomous Databases running on shared dedicated Exadata infrastructure. The ACD is a foundational layer in Oracle’s four-level Autonomous Database architecture and provides centralized lifecycle management, isolation, governance, patching, backup orchestration, and workload consolidation.

 Estimated Time: About one hour.

### Objectives

>**Autonomous Container Database (ACD)** can be created only from the OCI Console.

 - Create an Autonomous Container Database

## Create an Autonomous Container Database

1. Login to [AWS Management Console](https://us-east-1.console.aws.amazon.com/console/home?region=us-east-1) and search for Oracle Database@AWS

    ![In AWS Management Console, search for Oracle Database@AWS and then click on it](../prerequisites/images/odb-network-01.png " ")

    >**Security Notice:** To ensure data privacy and security, certain fields on screen captures in this workshop have been redacted. Sensitive fields—such as IP addresses, subscription IDs, and personal identifiers—are obscured using solid gray rectangular boxes.

2. Click on the **Dashboard** to go to Oralce Database@AWS resources dashboard

    ![Image](../prerequisites/images/odb-network-02.png " ")

3. From the left hand menu select **Autonomous VM clusters** and click on select your Autonomous VM cluster created in the previous lab

  ![Image](./images/ai-db-01.png" ")

  Then Click on **Manage in OCI**

 ![Image](./images/ai-db-02.png" ")

  This will take you to **OCI console** and This will display the details of your Autonomous VM Cluster

 ![Image](./images/ai-db-03.png" ")

 Click on the **Autonomous Container Database** tab and **Create Autonomous Container Database** screen is displayed. 

 ![Image](./images/ai-db-04.png" ")
4. Click on **Create Autonomous Container Database** and enter the following information and then click **Create**
 |Field|Value|
 |------|----|
 |Display name| DEMOADB|
 |Compartment|Select your appropriate compartment|
 |Autonomous Container Database name|DEMODB|
 |**Basic information for the Autonomous Container Database**||
 |Select version from base image|23.26.2.x|

 ![Image](./images/ai-db-05-01.png" ")

|Field|Value|
 |--|--|
 |**Automatic maintenance configuration**||
 |Maintenance method|Rolling|
 |Autonomous Container Database maintenance version|Next relaase update(RU)|
 |Maintenance Schedule|No scheduling preference specified|

  ![Image](./images/ai-db-05-02.png" ")
 
 |Field|Value|
 |-----|-----|
 |**Backups Configuration**|
 |Enable automatic backups|toggle to yes|
 |Retain backups for 72 hours, then delete| checked|
 |Backup Destination|Amazon S3|
 |Retention lock|unchecked|
 |Backup retention period (in days)|15|
 |Enable cross-region backup copy|unchecked|

 ![Image](./images/ai-db-05-04.png" ")

 |Field|Value|
 |-----|-----|
 |**Advanced options** ||
 |**Management**||
 |Autonomous AI Database resource management|default value|
 |Node Failover reservation|Default value|
 |Ditribution affinity|Default value|
 |**Net services architecture**||
 |Enable shared server configuration| Unchecked|
 |**Encryption key**||
 |Encrypt using an oracle managed key|Checked|
 |**Tags**||
 |Namespace|None|
 |Key|Function|
 |Value|LiveLab|

 ![Image](./images/ai-db-05-06.png" ")
 ![Image](./images/ai-db-05-07.png" ")

5. Once provisioned you can check the status and details of the created Autonomous Container Database 

 ![Image](./images/ai-db-06.png" ")

6. Click the **Home** link in the breadcrumbs to return to the **Home** page in preparation for the next lab.

**Congratulations! You have successfully created Autonomous Container Database!**.

**You may now proceed to the next lab.**.


## Learn More
* [Oracle AI Database@AWS](https://docs.oracle.com/en-us/iaas/Content/database-at-aws/oaaws.htm)
* [Autonomous AI Database on Dedicated Exadata Infrastructure](https://docs.oracle.com/en/cloud/paas/autonomous-database/dedicated/adbaa/index.html)


## Acknowledgements
- **Author:** Devinder Singh, Senior Principal Solutions Architect - Multicloud
- **Contributor:** Devinder Singh, Senior Principal Solutions Architect - Multicloud
- **Last Updated By/Date:** Devinder Singh, May 2026


