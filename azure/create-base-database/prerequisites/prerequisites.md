# Create the Required Resources to Create an Oracle Base Database Service

## Introduction

This lab walks you through creating the prerequisite resources to create an Oracle Base Database Service using Oracle Database@Azure. You will create a resource group, a virtual network (VNet), and a subnet that needs to be delegated to `Oracle.Database/networkAttachement`. You also create a public subnet that you will use when you deploy the virtual machine. 

Estimated Time: 15 minutes

### Objectives

You will login to Azure portal and perform the following tasks:
- Create a resource group 
- Create a virtual network
- Add a subnet to the virtual network
- Delegate the subnet to the Oracle Database@Azure Service
- Create a public subnet to use when you create the required Virtual Machine (VM)

## Task 1: Create a Resource Group

A resource group in Azure Portal is a logical container that holds related Azure resources such as virtual machines, databases, and storage accounts so they can be managed collectively. Resource groups help organize resources for management, monitoring, and access control based on lifecycle and permissions within a specific Azure subscription.

In this task, you will create a resource group.

1. Login to [Azure Portal](portal.azure.com). In the **Azure services** section, click the **Resource groups** icon. If the **Resource groups** icon is not displayed, you can search for it using the **Search resources, services, and docs** search field.

    ![Navigate to the Azure portal and click the Resource groups icon](./images/navigate-azure-portal.png " ")

    >**Security Notice:** To ensure data privacy and security, certain fields on screen captures in this workshop have been redacted. Sensitive fields—such as IP addresses, subscription IDs, and personal identifiers—are obscured using solid gray rectangular boxes.

2. On the **Resource groups** page, click **+ Create**.

    ![Create a new resource group](./images/click-create-resource-group.png " ")

    The **Create a resource group** page is displayed.

    ![The Create a resource group page is displayed](./images/create-resource-group-page.png " ")

3. On the **Basics** tab, specify the following details:
    - **Subscription:** Select your billing subscription from the drop-down list.
    - **Resource group name:** `training-adb-rg`.
    - **Region:** Select your region from the drop-down list.
    
        ![Complete the Basics tab](./images/basics-tab.png " ")

        Click **Next**.

4. On the **Tags** tab, create the following two tags. Tags are key-value pairs used to organize and manage your resources. 

    - **Tag 1**: Enter or select `Environment` for the name and `Training` for the value.
    - **Tag 2:** Enter or select `Created by` for the name and enter your name for the value.
        
        ![Complete the Tags tab](./images/tags-tab-rg.png " ")

        Click **Next**.

5. The **Review + create** page will validate the input provided in the previous steps. Once Validation is successful, click **Create** to create your new resource group.
    
    ![Click Create to create the resource group](./images/click-create-rg.png " ")

    A **Resource group created** message box is displayed. 

6. Enter `training` in the **Filter for any field** field to search for the newly created resource group, and then press [Enter].
    The new `training-adb-rg` is displayed. 

    ![Search for new resource group](./images/search-resource-group.png " ")

7. Click the **Home** link in the breadcrumbs to return to the Home page in preparation for the next task.

## Task 2:  Create a Virtual Network (VNet)

An Azure Virtual Network (VNet) is the fundamental building block for your private network in the cloud. It is a logically isolated section of the Azure network dedicated to your subscription, allowing resources like Virtual Machines (VMs) to communicate securely with each other, the internet, and on-premises networks. 

1. In the **Azure services** section, click the **Virtual networks** icon. If the **Virtual networks** icon is not displayed, you can search for it using the **Search resources, services, and docs** search field.

    ![Navigate to the Azure portal and click the Virtual networks icon](./images/navigate-virtual-networks.png " ")

2. On the **Virtual networks** page, click **+ Create**.

    ![Create a new virtual network](./images/click-create-virtual-network.png " ")

    The **Create virtual network** page is displayed with the **Basics** tab selected by default.

3. In the **Project details** section, specify the following:
    - **Subscription:** Select your billing subscription.
    - **Resource group:** `training-adb-rg`.
    - **Region:** Select your region.

4. In the **Instance details** section, specify the following:
    - **Virtual network name:** **`training-adb-vnet-2`**.
    - **Region:** Select your region.

        ![Complete the virtual network Basics tab](./images/vnet-basics-tab.png " ")

        Click **Next**.

5. On the **Security** tab, specify the following:
    - **Virtual network encryption:** Select this checkbox to enable the encryption of the traffic traveling within the VNet.
    - **Azure Bastian:** Unchecked (default). You can select this checkbox if Bastian Server is required to connect to a specific resource later.
    - **Azure Firewall:**  Unchecked (default). Similar to traffic encryption and Bastian service, you can enable the Azure Firewall if required.

        ![Complete the Security tab](./images/security-tab.png " ")

        Click **Next**. 

6. On the **IP addresses** tab, there is an option to add either the `IPV4` or the `IPV6` address space for your network resources. You can select the default IP Address range or provide a new IP range based on your requirement. In our example, accept the default `Add IPv4 address space`.

    ![The IP addresses page is displayed](./images/ip-addresses-page.png " ")

    Click **Next**.

7. Create the following two tags in the **Tags** tab:
    - **Tag 1:** Select `Environment` for the name and `Training` for the value.
    - **Tag 2:** Select `Created by` for the name and your name.
    
        ![Complete the Tags tab](./images/tags-tab-vnet.png " ")

        Click **Next**. 

8. The **Review + create** page will validate the input provided in the previous steps. If validation is successful, click **Create** to create your new virtual network.
    
    ![Click Create to create the virtual network](./images/validation-passed.png " ")

    A `"Your deployment is complete"` message is displayed on the **Overview** page. In addition, a **Deployment succeeded** message box is displayed briefly.

    ![Virtual network deployment successful message is displayed](./images/deployment-complete.png " ")

9. Click **Go to resource**.

10. Your new virtual network **Overview** page is displayed.

    ![Virtual network Overview page is displayed](./images/virtual-network-overview-page.png " ")

## Task 3: Add a Subnet and Delegate to Oracle Database@Azure Service

Subnets segment a virtual network (VNet) by allocating specific portions of its address space for resource deployment. For Oracle Database@Azure, creating a delegated subnet is a strict prerequisite for provisioning Oracle Exadata VM Clusters, Oracle Exascale VM Clusters, and Oracle Autonomous AI Database Serverless. 

In this task, you will create a new subnet and delegate it to the `Oracle Database@Azure` Service. This delegation grants the Oracle service exclusive authority to manage and deploy resources within that dedicated segment, ensuring seamless integration between Azure networking and Oracle Cloud Infrastructure (OCI). While the Oracle service manages specific network resources within the subnet to ensure stability and performance, you retain full ownership of the overall Virtual Network.

1. You should be already on your virtual network **Overview** page from **Task 2**. 

2. In the navigation tree on the left, click **Settings** > **Subnets**.

    ![Navigate to Settings > Subnets](./images/settings-subnets.png " ")

3. On the **Subnets** page, click **+ Subnet**.

    ![Click the add a subnet icon](./images/click-add-subnet.png " ")

4. On the **Add a subnet** page, specify the following:

    - **Subnet purpose:** Accept the `Default` selection. 
    - **Name:** Enter a meaningful name such as `training-snet-oracle-delegated`.
        
    Accept all the default selections in the **IPv4** section. You typically select an IP address range based on the size of network required for the deployment.

    ![Specify the Add a subnet page fields](./images/make-selections.png " ")

5. Scroll-down the page to the **Subnet Delegation** section. Click the drop-down list, enter `oracle` in the `Filter items` search text box, and then select `Oracle.Database/networkAttachments`.

    ![Select the subnet delegation](./images/select-subnet-delegation.png " ")

6. Click **Add** to add this subnet to your virtual network. The new subnet is displayed on the **Subnets** page.

    ![New subnet created](./images/new-subnet-created.png " ")

## Task 4: Add a Public Subnet

When you create your Oracle Base Database Service in Lab 4, you will use the **Managed private virtual network IP** only access type. This means your database is only reachable via your private Azure Virtual Network (VNet)—not publicly over the internet. This makes things secure, but it also means your application must be inside that private network to access the database, or if the application is in different VNet, then you must peer the VNets. If you want to access your database using a tool such as Oracle SQL Developer, the easiest way is to create a Virtual Machine (VM) in Azure in the same VNet as your database. You will do that in Lab 5; however, when you create the VM, you’ll need a public subnet. A public subnet is a section of your Azure network that has an "Internet Gateway". This allows the resources inside it to communicate with the outside world. Let’s create a public subnet that you will use when you create your VM.

1. You should be already on your virtual network **Subnets** page from **Task 3**. 

2. Click **+ Subnet**.

3. On the **Add a subnet** page, specify the following:

    - **Subnet purpose:** Accept the `Default` selection. 
    - **Name:** Enter a meaningful name such as `training-public-subnet`.
    - **Enable private subnet (no default outbound access):** Make sure this checkbox is **unchecked** in order to create a public subnet.

        ![Keep checkbox unchecked](./images/private-subnet-section.png " ")
        
    - Accept all the default selections in the **IPv4** section. You typically select an IP address range based on the size of network required for the deployment.

4. Click **Add** to add the public subnet to your virtual network. The new subnet is displayed on the **Subnets** page.

    ![Add public subnet](./images/add-public-subnet.png " ")

5. Click the **Home** link in the breadcrumbs to return to the **Home** page in preparation for the next lab.

**Congratulations! You have successfully created the required resources to create an Oracle Base Database Service!**.

You may now proceed to the next lab.

## Learn More
* [Oracle Database@Azure](https://docs.oracle.com/en-us/iaas/Content/database-at-azure/oaa.htm)
* [What is a resource group?](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/overview#resource-groups)
* [What is Azure Virtual Network?](https://learn.microsoft.com/en-us/azure/virtual-network/virtual-networks-overview)
* [Delegated Subnet Design](https://docs.oracle.com/en-us/iaas/Content/database-at-azure/network-delegated-subnet-design.htm)
* [Add, change, or delete a virtual network subnet](https://learn.microsoft.com/en-us/azure/virtual-network/virtual-network-manage-subnet?tabs=azure-portal)

## Acknowledgements
- **Author:** Lauran K. Serhal, Consulting User Assistance Developer, Oracle Autonomous AI Database and Multicloud
- **Contributors:**
    * Devinder Singh, Senior Principal Solutions Architect - Multicloud
    * Sanjay Rahane, Principal Cloud Architect, North America Cloud Engineering Services (CES)
    * Tejus Subrahmanya, Principal Product Manager
* **Last Updated By/Date:** Lauran K. Serhal, March 2026