## Introduction

This lab walks you through creating an **Autonomous AI Database on Dedicated Exadata Infrastructure.**

**Oracle Autonomous AI Database** on Oracle AI Database@AWS is Oracle’s fully managed, self-driving database service deployed on dedicated Exadata infrastructure inside AWS data centers. It combines Oracle’s autonomous database automation with the low-latency, native integration of AWS services, enabling enterprises to run mission-critical Oracle workloads close to their AWS applications while minimizing operational overhead.

 Estimated Time: About 30 minutes.

### Objectives

>**Autonomous AI Database on Dedicated Exadata Infrastructure** can be created only from the OCI Console. 

 - Create an Autonomous AI Database on Dedicated Exadata Infrastructure.

## Create an Autonomous AI Database on Dedicated Exadata Infrastructure.

1. Login to [AWS Management Console](https://us-east-1.console.aws.amazon.com/console/home?region=us-east-1) and search for Oracle Database@AWS

    ![In AWS Management Console, search for Oracle Database@AWS and then click on it](../prerequisites/images/odb-network-01.png " ")

    >**Security Notice:** To ensure data privacy and security, certain fields on screen captures in this workshop have been redacted. Sensitive fields—such as IP addresses, subscription IDs, and personal identifiers—are obscured using solid gray rectangular boxes.

2. Click on the **Dashboard** to go to Oralce Database@AWS resources dashboard

    ![Image](../prerequisites/images/odb-network-02.png " ")

3. From the left hand menu select **Autonomous VM clusters** and click on select your Autonomous VM cluster created in the previous lab

  ![Image](./images/ai-db-01-01.png" ")

  Then Click on **Manage in OCI**

 ![Image](./images/ai-db-01-02.png" ")

  This will take you to **OCI console** and This will display the details of your Autonomous VM Cluster

 ![Image](./images/ai-db-01-03.png" ")

 Click on the **Autonomous Container Database** tab and select the Autonomous Container Database created in the previous lab. 

 ![Image](./images/ai-db-04-00.png" ")

 This will take you to the details of your container database. 
  ![Image](./images/ai-db-01-05.png" ")

 Click on the Autonomous AI Databases tab and then click Create Autonomous AI Database

 ![Image](./images/ai-db-01-06.png" ")

 4. This will open the **Create Autonomous AI Database on Dedicated Exadata Infrastructure** screen, Here enter the relevant information and click  **Create**

 
 ![Image](./images/ai-db-04-01.png" ")
 ![Image](./images/ai-db-04-02.png" ")
 ![Image](./images/ai-db-04-03.png" ")
 ![Image](./images/ai-db-04-04.png" ")
 ![Image](./images/ai-db-04-05.png" ")

5. Once provisioned you can check the status and details of the created Autonomous AI Database on Dedicated Exadata Infrastructure.

 ![Image](./images/ai-db-04-07.png" ")

6. Click the **Home** link in the breadcrumbs to return to the **Home** page in preparation for the next lab.

**Congratulations! You have successfully created Autonomous AI Database on Dedicated Exadata Infrastructure!**.

**You may now proceed to the next lab.**.


## Learn More
* [Oracle AI Database@AWS](https://docs.oracle.com/en-us/iaas/Content/database-at-aws/oaaws.htm)
* [Autonomous AI Database on Dedicated Exadata Infrastructure](https://docs.oracle.com/en/cloud/paas/autonomous-database/dedicated/adbaa/index.html)


## Acknowledgements
- **Author:** Devinder Singh, Senior Principal Solutions Architect - Multicloud
- **Contributor:** Devinder Singh, Senior Principal Solutions Architect - Multicloud
- **Last Updated By/Date:** Devinder Singh, May 2026


