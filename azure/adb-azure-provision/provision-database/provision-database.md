
# Provision an Oracle Autonomous AI Database

## Introduction

This lab walks you through the steps to provision an Oracle Autonomous AI Database using the Azure portal.  

Estimated Time: 10 minutes

### Objectives

In this lab, you will:

- Provision an Oracle Autonomous AI Database in `Oracle Database@Azure`
- Place the database in your resource group and Microsoft Azure region
- Configure the database according to your requirements
- Review your Oracle Autonomous AI Database in OCI

### Prerequisites

- This lab requires the completion of **Lab 1: Create the Required Resources** in the **Contents** menu on the left.
- Your Azure subscription must be onboarded and linked to an Oracle Cloud Infrastructure (OCI) tenancy.
- You must have a valid OCI user account with permissions to view and manage Autonomous AI Database resources within the OCI console.

## Task 1: Create an Oracle Autonomous AI Database

1.	Login to the [Azure Portal](portal.azure.com) using your credentials, if you are not already logged in. In the **Azure services** section, click the `Oracle Database@Azure` icon.

    ![Click the Oracle Database@Azure icon.](./images/click-oracle-azure.png " ")

2. On the **Oracle Database@Azure | Overview** page, in the Oracle Autonomous AI Database section, click **Create an Autonomous AI Database**.

    ![click Create an Autonomous AI Database](./images/click-create-adb.png " ")

    >**Note:** Alternatively, you can click **Oracle Autonomous Database Service** from the navigation menu on the left, and then click **+ Create**.

    The **Create Oracle Autonomous AI Database** page is displayed. This is where you'll specify the configuration for your database instance.

3. In the **Basics** tab, specify the following:
    - **Subscription:** Select your billing subscription from the drop-down list.
    - **Resource group:** Select the resource group that you created in **Lab 1 > Task 1**, `training-adb-rg` in our example.
    - **Name:** Enter a meaningful name for your Autonomous AI Database such as **`training4azureadb`**. 
        >**Note:** The value must contain only letters and numbers, starting with a letter. 30 characters max. Spaces, dashes, and underscores are not allowed.    

    - **Region:** Select your region from the drop-down list.
    
        ![Complete the Basics tab](./images/basics-tab.png " ")

        Click **Next**.

4. In the **Configuration** tab, specify the following:
    - **Workload type:** Select **`Transaction Processing`** from the drop-down list. Supported workload types include `Lakehouse`, `Transaction Processing`, `JSON`, and `APEX`.
    - **Database version:** Select **`26ai`** from the drop-down list. The other choice is `19c`.
    - **ECPU count:** `2`.
    - **Compute auto scaling:** `checked`.
    - **Storage (TB):** `500 GB`.
    - **Storage auto scaling:** `unchecked`.
    - **Backup retention period in days:** `60`.
    - **Administrator password:** Enter (and confirm) a meaningful password for the `ADMIN` account such as **`Training4ADB`**. **Important:** Make a note of this password as you will need it to perform later tasks.
    
        >**Note:** The password must be between 12 and 30 characters, and contain at least one uppercase letter, one lowercase letter, and one number. The password cannot contain a double quote character (") or the username `ADMIN`. 
    - **License type:** Select **`License included`** from the drop-down list. The other available choice is `Bring your own license (BYOL)`.

    - Click the **Advance options** checkbox to view the available options. Accept the default selections for **Character set** and **National character set**. 

        ![Complete the Configuration tab](./images/configuration-tab.png " ")
    
        Click **Next**.
 
5. In the **Networking** tab, specify the following:
    - **Access type:** `Managed private virtual network IP only`. 
    - **Require mutual TLS (mTLS) authentication:** Unchecked.    
        **Note:** TLS connections allow you to connect to your Oracle Autonomous AI Database without a wallet, if you use a JDBC thin driver with 
        JDK8 or above. TLS connections require you to use an access control list (ACL) or private endpoint.
    
    - **Virtual network:** Select your virtual network that you created in **Lab 1 > Task 2**, `training-adb-vnet-eastus` in our example.
    - **Subnet:** The subnet that you created and added to your virtual network is automatically selected, `training-snet-oracle-delegated` in our example. 
    
        ![Complete the Networking tab](./images/networking-tab.png " ")
    
        Click **Next**.

6.  In the **Maintenance** tab, specify the following:
    - **Maintenance patch level:** `Regular`.
    - **Email address:** Enter one or more email addresses to receive operational notices and announcements as well as unplanned maintenance notifications.
    
        ![Complete the Maintenance tab](./images/maintenance-tab.png " ")

        Click **Next**.

7. In the **Consent** tab, agree to the terms of services, and then click **Next**.

    ![Complete the consent tab](./images/consent-tab.png " ")

    Click **Next**.

8. In the **Tags** tab, provide the following two tags and values: 
    - **Tag 1:** Select `Environment` for the name and `Training` for the value.
    - **Tag 2:** Select `Created by` for the name and your name for the value.
    
        ![Complete the Tags tab](./images/tags-tab.png " ")

        Click **Next**.

9. In the the **Review + create** tab, review the information you specified in the **Basics**, **Configuration**, **Networking and Maintenance** and make any corrections, if needed. 

    ![Complete the Review + create tab](./images/review-create.png " ")

10. Click **Create** to initiate the Oracle Autonomous AI Database creation process. The **Deployment is in progress** message is displayed on the page. The deployment could take up to (30) minutes to complete.

    ![Deployment in progress](./images/deployment-in-progress.png " ")

11. When the deployment is complete, a **Your deployment is complete** message is displayed on the page.

    ![Deployment is complete](./images/deployment-complete.png " ")

12. Click **Go to Resources**. The **Resource group** page is displayed. In the **Filter for any field** text box, enter `training`. The newly provisioned Autonomous AI Database is displayed.

    ![New Autonomous AI Database is displayed](./images/adb-displayed.png " ")

## Task 2: Review your Provisioned Oracle Autonomous AI Database in OCI

In this task, you will learn how to view your newly provisioned Oracle Autonomous AI Database in OCI. 

1. Click the **Home** link in the breadcrumbs. 

2. In the **Azure services** section, click the `Oracle Database@Azure` icon.

3. On the **Oracle Database@Azure | Overview** page, click the **Oracle Autonomous AI Database** node in the navigation menu on the left. In the **Filter for any field** text box, enter `training`. The newly provisioned Autonomous AI Database is displayed.

    ![The new Autonomous AI Database is displayed](./images/new-adb-displayed.png " ")

4. Click the Autonomous AI Database name link to display the **Overview** page. 

5. Go to the **Essentials** section **> OCI Database URL** field, click the **Go to OCI** link.

    ![Click Go to OCI link](./images/click-go-oci.png " ")

    **Note:** To click the **Go to OCI** link in the Azure portal and successfully display your provisioned Oracle Autonomous AI Database, you must meet specific identity and configuration requirements such as:
    - **Linked OCI Tenancy:** Your Azure subscription must be onboarded and linked to an Oracle Cloud Infrastructure (OCI) tenancy.
    - **OCI Permissions:** You must have a valid OCI user account with permissions to view and manage Autonomous Database resources within the OCI console.

6. On the OCI Login page, enter your credentials to sign in to OCI. Once you are  authenticated, the **Autonomous AI Database** details page within the OCI Consol is displayed.  

    ![The ADB details page](./images/adb-details-page.png " ")

7. Click **Database actions**. The **Database actions** message box is displayed with important information, and the URL to access Database actions. Click **Copy** to copy the URL to a text editor of your choice. You will need this URL later. Next, click **Close**.

    ![Database actions message box and URL](./images/db-actions-url.png " ")

    To access your Oracle Autonomous AI Database actions, you must use a "Jump Box" (Virtual Machine or VM) located within the same private network (VNet), as private endpoints are not accessible from the public internet. If you try to use the provided URL, you'll get an error message. If you don't have a VM, proceed to **Lab 3** to deploy one.

<!-- This is a single-line comment 
Task 3 is now Lab 3: (Optional) Create a Virtual Machine to Access Database Actions in your Provisioned Oracle Autonomous AI Database
To access your Oracle Autonomous AI Database actions, you must use a "Jump Box" (Virtual Machine or VM) located within the same private network (VNet), as private endpoints are not accessible from the public internet. If you don't have a VM, use the following steps to deploy one.
    
**Part 1: Create a Virtual Machine in Azure Portal**

Deploy a Virtual Machine (VM) that can "see" your private Oracle Autonomous AI Database as follows:

1.	On the Azure Portal Home page, search for **Virtual machines**, and then select **+ Create > Virtual machine**.

2.	On the **Basics** tab, specify the following: 
    - **Resource Group:** Select the resource group that contains your database, `training-adb-rg` in our example.
    - **Security type:** `Standard`.
    - **Image:** In our example, we will choose `Windows 11 Pro, version 25H2 - x64 Gen2` (select the option that is appropriate for you).
    - **Size:** Select at least 2 vCPUs and 8 GB RAM for stability. In our example, we chose `Standard_B2as_v2 – vcpus, 8 GiB memory`.
    - **Administrator Account:** Enter a username and a strong password that you can remember.
    - **Public inbound ports:** `Allow selected ports`.
    - **Select inbound ports:** `RDP (3389)`.
    - **Delete public IP and NIC when VM is deleted:** `Checked`.
    - **Licensing:** `Checked`.

        ![The VM Basics tab](./images/vm-basics-tab.png " ")

3.	On the **Networking** tab (Critical), specify the following:
    - **Virtual Network:** Select the same VNet where your Oracle Autonomous AI Database is provisioned, `training-oracle-vm` in our example.
    - **Subnet:** Choose a subnet that has routing access to the database's private subnet.

        ![The VM Networking tab](./images/vm-networking-tab.png " ")

4.	Click the **Review + create** tab. If the `Validation passed` message is displayed, click **Create**. 

     ![The Validation passed message is deployed](./images/validation-passed.png " ")

5. When the VM is deployed, a `Your deployment is complete` message is displayed.

    ![The VM is deployed](./images/vm-deployed.png " ")

6. Click **Go to resource**. Your VM **Overview** page is displayed. Expand the **Connect** node in the navigation tree, and then click **Connect**.

    ![Go to resource](./images/go-to-resource.png " ")

7. On the **Connect** page, click **Check access**.

    ![Check access](./images/check-access.png " ")

8. A `Port 3389 is accessible from source IP(s)` message is displayed.

    ![Port 3389 is accessible](./images/port-accessible.png " ")

9. In the **Connect using RDP file** section, click **Download RDP file** to obtain the connection details for remote access to your Azure Windows VM; an RDP (.rdp) file or Remote Desktop Protocol, is a pre-configured configuration file that allows you to connect to a Windows Virtual Machine (VM) using the Remote Desktop Protocol. The file will be saved in your default `Downloads` folder as the VM's name such as `training-oracle-azure-vm.rdp` (or with your VM's name, if different).

**Part 2: Connect to the VM via Remote Desktop Protocol (RDP)**

>**Note:** To ensure a stable connection to your VM, please disconnect any active VPNs before attempting to connect. Certain VPN configurations may block the specific ports or protocols required for the workshop environment.

Once the VM is **Running**, connect to it from your local computer as follows:

1. Double-click the downloaded `training-oracle-azure-vm.rdp` file to start the remote connection. If prompted with a security warning about the remote computer's identity, click **Connect** to continue.

2. On the **Enter your credentials** dialog box, enter your VM's credentials, and then click **OK**.

    ![Enter your VM's credentials](./images/enter-vm-credentials.png " ")

3. The VM is displayed. 

**Part 3: Access Database Actions from the VM**

Since your VM is now inside the private network, it can resolve the database's private URL.

1. Inside the Remote Desktop session (on the Windows 11 VM), open Microsoft Edge. 

    ![The VM is displayed](./images/vm-displayed.png " ")

2. Paste the Database actions URL from OCI that you copied in Task 2 into the browser.

3. Sign in as the `ADMIN` user with the password you set during database provisioning. The **Database Actions Launchpad** is displayed. You can now access SQL Worksheet, Data Modeler, and other tools. 

4. To access the SQL Worksheet, click the **Development** tab, and then click the **SQL** tab.

    ![Navigate to the SQL Worksheet](./images/navigate-sql-2.png " ")

5. Copy the following query, paste it into the SQL Worksheet, and then click the **Run Statement** icon on the toolbar. The results are displayed in the **Query Result** tab.

    ```
    <copy>
    SELECT *
    FROM sh.countries;
    </copy>
    ```
    
    ![Run the query](./images/run-query.png " ")-->

**All Done! You have successfully deployed your Oracle Autonomous AI Database instance and accessed the database in OCI.**

You may now **proceed to the next lab**.

## Learn More
* [Oracle Database@Azure](https://docs.oracle.com/en-us/iaas/Content/database-at-azure/oaa.htm)
* [Create an Autonomous AI Database using the Azure portal](https://docs.oracle.com/en-us/iaas/Content/database-at-azure/azucr-create-autonomous-ai-database.html#GUID-F48CC33E-E53F-44AD-BB36-BE4FC183368E)

## Acknowledgements
- **Author:** Lauran K. Serhal, Consulting User Assistance Developer, Oracle Autonomous AI Database and Multicloud
- **Contributors:**
    * Devinder Singh, SR Principal Solutions Architect - Multicloud
    * Tejus Subrahmanya, Principal Product Manager
* **Last Updated By/Date:** Lauran K. Serhal, February 2026