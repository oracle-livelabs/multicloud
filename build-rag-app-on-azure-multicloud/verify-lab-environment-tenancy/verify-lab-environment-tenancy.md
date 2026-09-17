# Verify Lab Environment

## Introduction

Verify the Azure networking, Azure OpenAI, and Azure Machine Learning resources you provisioned.

### Objectives

* Verify the resource group, virtual network, and subnets.
* Verify the Azure OpenAI deployments.
* Verify the Azure Machine Learning workspace and compute.

Estimated Time: 10 minutes

## Task 1: Verify the lab environment

Verify each resource before you provision Oracle Autonomous AI Database.

### Verify your Azure Resource Group

1. Login to [Azure Portal](https://portal.azure.com/#home), search for Resource Groups, and select **Resource Groups** from the list.

    ![Azure portal workshop environment verification screen 1](images/verify-lab-environment-01.png)

2. From the available list of **Resource Groups**, take a note of the Resource Group **lab-rg-01**.

    ![Azure portal workshop environment verification screen 2](images/verify-lab-environment-02.png)

### Verify your Azure VNET & Subnets

1. On the Azure Portal, search for **VNET**, and select **Virtual network** from the list.

    ![Azure portal workshop environment verification screen 3](images/verify-lab-environment-03.png)

2. Take note of the available Virtual network **lab-vnet-01** name. Select the **lab-vnet-01** VNET and navigate to **Subnets**.

    ![Azure portal workshop environment verification screen 4](images/verify-lab-environment-04.png)

3. From the list of available **Subnets**, select **lab-client-subnet**.

    ![Azure portal workshop environment verification screen 5](images/verify-lab-environment-05.png)

4. On the **Edit subnet** page, take note of the **Subnet Delegation** value, **Oracle.Database/networkAttachments**. Oracle Autonomous AI Database is created using this **Delegated Subnet**.

    ![Azure portal workshop environment verification screen 6](images/verify-lab-environment-06.png)

5. From the list of available **Subnets**, select **lab-application-subnet**. On the Edit subnet page, take note of the Service Endpoints list. **Microsoft.CognitiveServices** service endpoint policy is a prerequisite for the **Azure OpenAI** resource deployment.

    ![Azure portal workshop environment verification screen 7](images/verify-lab-environment-07.png)

### Azure OpenAI Resource and Deployment

1. On the [Azure Portal](https://portal.azure.com/#home), search for **Azure OpenAI** and select **Azure OpenAI** from the list.

    ![Azure portal workshop environment verification screen 8](images/verify-lab-environment-08.png)

2. From the list of available Azure OpenAI instances, select **lab-azure-openai-service**.

    ![Azure portal workshop environment verification screen 9](images/verify-lab-environment-09.png)

3. Expand the left-menu on the **Azure OpenAI** page and select **Keys and Endpoint**.

    ![Azure portal workshop environment verification screen 10](images/verify-lab-environment-10.png)

4. Take note of KEY 1, Location/Region, and Endpoint values, which are used to call the **OpenAI** API.

    ![Azure portal workshop environment verification screen 11](images/verify-lab-environment-11.png)

5. Navigate to the **Networking** section of the **lab-azure-openai-service**. Azure OpenAI resources are securely deployed within the lab-application-subnet to ensure secure communication.

    ![Azure portal workshop environment verification screen 12](images/verify-lab-environment-12.png)

6. Select **Overview** to return to the main window, and select **Explore Foundry portal**.

    ![Azure portal workshop environment verification screen 13](images/verify-lab-environment-13.png)

7. This opens a new tab and takes you to the **Chat playground** page within the **Microsoft Foundry** | **Azure OpenAI** portal.

    ![Azure portal workshop environment verification screen 14](images/verify-lab-environment-14.png)

8. Select **Deployment** from the left-menu and select **lab-azure-openai-deployment** on the **Model deployments** page.

    ![Azure portal workshop environment verification screen 15](images/verify-lab-environment-15.png)

9. Take note of the **Model name** `text-embedding-3-small` and sample code to use with Python and other languages. Select the left arrow next to **lab-azure-openai-deployment** to return to the Deployments page.

    ![Azure portal workshop environment verification screen 16](images/verify-lab-environment-16.png)

10. Select **lab-azure-openai-chat-deployment** on the **Model deployments** page. Take note of the **Model name** `gpt-5.4-mini` and sample code to use with Python and other languages.

    ![Azure portal workshop environment verification screen 17](images/verify-lab-environment-17.png)

### Azure Machine Learning Workspace & Compute

1. On the [Azure Portal](https://portal.azure.com/#home), search for **Azure Machine Learning** and select it.

    ![Azure portal workshop environment verification screen 18](images/verify-lab-environment-18.png)

2. Select **lab-aml-ws** from the list of available Azure Machine Learning Workspaces.

    ![Azure portal workshop environment verification screen 19](images/verify-lab-environment-19.png)

3. Take a note of the **Azure Key Vault**, **Application Insights**, and **Storage account**, which are created already as prerequisite. Select **Launch studio**.

    ![Azure portal workshop environment verification screen 20](images/verify-lab-environment-20.png)

4. A new tab opens with the **Microsoft Foundry** | **Azure Machine Learning** Dashboard. Using the left-menu, select **Model catalog**. You have the option to select from a list of available hosted models. You use **text-embedding-3-small** from **OpenAI** through **Azure OpenAI Service**.

    ![Azure portal workshop environment verification screen 21](images/verify-lab-environment-21.png)

    ![Azure portal workshop environment verification screen 22](images/verify-lab-environment-22.png)

5. Navigate to the **Compute** page from the left-menu. Filter the list by typing the last 3 digit of your user name. Confirm it’s in **Running** state. Select the Compute **Name**.

    ![Azure portal workshop environment verification screen 23](images/verify-lab-environment-23.png)

6. Azure Machine Learning Compute is created using the **lab-application-subnet** within the **lab-vnet-01 Azure** VNET to ensure secure communication between the database server and Azure ML compute.

    ![Azure portal workshop environment verification screen 24](images/verify-lab-environment-24.png)

## Acknowledgements

* **Authors** - Rajib Sadhu and Bill Sawyer
* **Source** - [Build a RAG App in 90 Minutes - Oracle AI Vector Search Meets Your Favorite LLM](https://docs.oracle.com/en/cloud/paas/multicloud/database-at-azure/latest/azlab/overview.html).
* **External assets** - Microsoft Azure interface screenshots and the referenced McAuley-Lab/Amazon-Reviews-2023 dataset material. Built with permission from the author(s).
* **Last Updated By/Date** - Rajib Sadhu, June 12, 2026
