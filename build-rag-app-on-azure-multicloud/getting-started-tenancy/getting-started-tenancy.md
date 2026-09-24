# Azure Regular Account

## Introduction

Provision the Azure resources required to run this workshop in your own subscription.

### Objectives

* Create the required Azure networking resources.
* Create Azure OpenAI deployments.
* Create the Azure Machine Learning workspace and compute.
* Assign the required permissions.

Estimated Time: 15 minutes

## Task 1: Prepare an Azure Regular Account

If you’re using your own Azure account, or you are advised by OCI staff to configure the workshop environment, you need to setup resources in Azure that enable you to complete the lab. You need to check that your Azure account has the necessary permissions to create the resources needed for this workshop. The steps to provision the resources that are required for this lab are as follows:

The Azure CLI simplifies infrastructure provisioning allowing you to focus on the lab.

Complete the Oracle AI Database@Azure **[Onboarding](https://docs.oracle.com/en-us/iaas/Content/database-at-azure/oaaonboard.htm)** using either **Private** or **Public offer** as prerequisites. The following steps require that this has already been successfully completed.

1. Create your Azure Resource Group, VNET, and Delegated Subnet.

    ```bash
    <copy>
    # Define variables
    RESOURCE_GROUP="lab-rg-01"
    LOCATION="eastus"
    VNET_NAME="lab-vnet-01"
    ADDRESS_PREFIX="143.0.0.0/16"
    SUBNET_NAME="lab-application-subnet"
    SUBNET_PREFIX="143.0.1.0/24"
    DELEGATED_SUBNET_NAME="lab-client-subnet"
    DELEGATED_SUBNET_PREFIX="143.0.2.0/24"
    
    # Create a Resource Group
    az group create \
      --name $RESOURCE_GROUP \
      --location $LOCATION
    
    # Create the Virtual Network and the default subnet
    az network vnet create \
      --resource-group $RESOURCE_GROUP \
      --name $VNET_NAME \
      --address-prefixes $ADDRESS_PREFIX \
      --subnet-name $SUBNET_NAME \
      --subnet-prefixes $SUBNET_PREFIX
    
    # Required for subnet-based network rules in Azure OpenAI resource setup
    az network vnet subnet update \
      --resource-group $RESOURCE_GROUP \
      --vnet-name $VNET_NAME \
      --name $SUBNET_NAME \
      --service-endpoints Microsoft.CognitiveServices \
      --output table
    
    # Create the delegated subnet for Oracle Database@Azure
    az network vnet subnet create \
      --resource-group $RESOURCE_GROUP \
      --vnet-name $VNET_NAME \
      --name $DELEGATED_SUBNET_NAME \
      --address-prefixes $DELEGATED_SUBNET_PREFIX \
      --delegations "Oracle.Database/networkAttachments"
    </copy>
    ```

2. Create your Azure OpenAI Resource and Deployment.

    ```bash
    <copy>
    # Define variables
    AOAI_NAME="lab-azure-openai-service"
    RESOURCE_GROUP="lab-rg-01"
    LOCATION="eastus"
    AOAI_DOMAIN_NAME="lab-azure-openai-domain"
    VNET_NAME="lab-vnet-01"
    SUBNET_NAME="lab-application-subnet"
    DEPLOYMENT_NAME="lab-azure-openai-deployment"
    MODEL_NAME="text-embedding-3-small"
    MODEL_VERSION="1"
    DEPLOYMENT_SKU_NAME="GlobalStandard"
    DEPLOYMENT_SKU_CAPACITY="10000"
    CHAT_DEPLOYMENT_NAME="lab-azure-openai-chat-deployment"
    CHAT_MODEL_NAME=" gpt-5.4-mini"
    CHAT_MODEL_VERSION="2026-03-17"
    
    # Create Azure OpenAI resource
    az cognitiveservices account create \
      --name $AOAI_NAME \
      --resource-group $RESOURCE_GROUP \
      --location $LOCATION \
      --kind OpenAI \
      --sku S0 \
      --custom-domain $AOAI_DOMAIN_NAME \
      --yes \
      --output table
    
    AOAI_ID=$(
    az cognitiveservices account show \
      --name $AOAI_NAME \
      --resource-group $RESOURCE_GROUP \
      --query id \
      --output tsv
    )
    
    SUBNET_ID=$(
    az network vnet subnet show \
      --resource-group $RESOURCE_GROUP \
      --vnet-name $VNET_NAME \
      --name $SUBNET_NAME \
      --query id \
      --output tsv
    )
    
    # Add subnet allow rule.
    az cognitiveservices account network-rule add \
      --resource-group $RESOURCE_GROUP \
      --name $AOAI_NAME \
      --subnet $SUBNET_ID \
      --output table
    
    az cognitiveservices account deployment create \
      --name $AOAI_NAME \
      --resource-group $RESOURCE_GROUP \
      --deployment-name $DEPLOYMENT_NAME \
      --model-name $MODEL_NAME \
      --model-version $MODEL_VERSION \
      --model-format OpenAI \
      --sku-name $DEPLOYMENT_SKU_NAME \
      --sku-capacity $DEPLOYMENT_SKU_CAPACITY \
      --output table
    
    # Deploy gpt-5.4-mini
    az cognitiveservices account deployment create \
      --name $AOAI_NAME \
      --resource-group $RESOURCE_GROUP \
      --deployment-name $CHAT_DEPLOYMENT_NAME \
      --model-name $CHAT_MODEL_NAME \
      --model-version $CHAT_MODEL_VERSION \
      --model-format OpenAI \
      --sku-name $DEPLOYMENT_SKU_NAME \
      --sku-capacity $DEPLOYMENT_SKU_CAPACITY \
      --output table
    </copy>
    ```

3. Create your Azure Machine Learning Studio Workspace.

    ```bash
    <copy>
    Create Storage Account: labamlwsstorageaccount
    Create Key Vault: lab-aml-ws-key-vault
    Create Application Insights: lab-aml-ws-app-insights
    
    # Define variables
    WORKSPACE_NAME="lab-aml-ws"
    RESOURCE_GROUP="lab-rg-01"
    LOCATION="eastus"
    STORAGE_ACCOUNT_NAME="labamlwsstorageaccount"
    KEY_VAULT_NAME="lab-aml-ws-key-vault"
    APP_INSIGHTS_NAME="lab-aml-ws-app-insights"
    
    STORAGE_ACCOUNT_ID="$(
    az storage account show \
      --name $STORAGE_ACCOUNT_NAME \
      --resource-group $RESOURCE_GROUP \
      --query "id" \
      -o tsv
    )"
    
    KEY_VAULT_ID="$(
    az keyvault show \
      --name $KEY_VAULT_NAME \
      --resource-group $RESOURCE_GROUP \
      --query "id" \
      -o tsv
    )"
    
    APP_INSIGHTS_ID="$(
    az monitor app-insights component show \
      --app $APP_INSIGHTS_NAME \
      --resource-group $RESOURCE_GROUP \
      --query "id" \
      -o tsv
    )"
    
    # Create Azure Machine Learning Workspace
    az ml workspace create \
      --name $WORKSPACE_NAME \
      --resource-group $RESOURCE_GROUP \
      --location $LOCATION \
      --storage-account $STORAGE_ACCOUNT_ID \
      --key-vault $KEY_VAULT_ID \
      --application-insights $APP_INSIGHTS_ID \
      --output table
    </copy>
    ```

4. Create your Azure Machine Learning Compute.

    ```bash
    <copy>
    # Define variables
    WORKSPACE_NAME="lab-aml-ws"
    RESOURCE_GROUP="lab-rg-01"
    LOCATION="eastus"
    COMPUTE_NAME="lab-aml-ws-compute002"
    COMPUTE_SIZE="Standard_DS11_v2"
    VNET_NAME="lab-vnet-01"
    SUBNET_NAME="lab-application-subnet"
    
    # Get the full subnet resource ID
    SUBNET_ID=$(az network vnet subnet show \
      --resource-group $RESOURCE_GROUP \
      --vnet-name $VNET_NAME \
      --name $SUBNET_NAME \
      --query id \
      --output tsv)
    
    # Create Azure Machine Learning Workspace Compute
    az ml compute create \
      --name $COMPUTE_NAME \
      --type ComputeInstance \
      --size $COMPUTE_SIZE \
      --resource-group $RESOURCE_GROUP \
      --workspace-name $WORKSPACE_NAME \
      --subnet $SUBNET_ID \
      --output table
    </copy>
    ```

5. Grant permission to your Lab user (Optional).

    ```bash
    <copy>
    # Create lab access group in Entra ID (grp-odbaa-hol-attendees)
    # Create lab users in Entra ID (e.g., labuser002@oraclemulticloudlabs.onmicrosoft.com)
    # Add users in the lab group
    
    # Define variables
    SUBSCRIPTION_ID="93fea712-***********-f5c94fef0af4"
    RESOURCE_GROUP="lab-rg-01"
    ENTRA_GROUP_NAME="grp-odbaa-hol-attendees"
    ROLE_NAME="Oracle.Database Autonomous Database Administrator"
    WORKSPACE_NAME="lab-aml-ws"
    VNET_NAME="lab-vnet-01"
    OPENAI_RESOURCE_NAME="lab-azure-openai-service"
    
    ENTRA_GROUP_OBJECT_ID=$(az ad group show \
      --group $ENTRA_GROUP_NAME \
      --query id \
      --output tsv)
    
    # Grant permission to see the Azure Resource Group
    az role assignment create \
      --assignee-object-id $ENTRA_GROUP_OBJECT_ID \
      --assignee-principal-type Group \
      --role "Reader" \
      --scope "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP" \
      --output table
    
    # Grant permission to create Oracle Autonomous AI Database
    ROLE_DEFINITION_ID=$(az role definition list \
      --name "$ROLE_NAME" \
      --query "[0].name" \
      --output tsv 2>/dev/null || true)
    
    az role assignment create \
      --assignee-object-id $ENTRA_GROUP_OBJECT_ID \
      --assignee-principal-type Group \
      --role $ROLE_DEFINITION_ID \
      --scope "/subscriptions/$SUBSCRIPTION_ID" \
      --output table
    
    # Grant permission to use Azure ML workspace and notebooks
    az role assignment create \
      --assignee-object-id $ENTRA_GROUP_OBJECT_ID \
      --assignee-principal-type Group \
      --role "AzureML Data Scientist" \
      --scope "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP/providers/Microsoft.MachineLearningServices/workspaces/$WORKSPACE_NAME" \
      --output table
    
    # Grant permission to create/start/stop/manage AML compute
    az role assignment create \
      --assignee-object-id $ENTRA_GROUP_OBJECT_ID \
      --assignee-principal-type Group \
      --role "AzureML Compute Operator" \
      --scope "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP/providers/Microsoft.MachineLearningServices/workspaces/$WORKSPACE_NAME"
    
    # Grant permission to edit notebook files in workspace storage
    az role assignment create \
      --assignee-object-id $ENTRA_GROUP_OBJECT_ID \
      --assignee-principal-type Group \
      --role "Storage File Data Privileged Contributor" \
      --scope "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP/providers/Microsoft.Storage/storageAccounts/labamlwsstorageaccount"
    
    # Grant permission to read/write blob-backed AML artifacts/data
    az role assignment create \
      --assignee-object-id $ENTRA_GROUP_OBJECT_ID \
      --assignee-principal-type Group \
      --role "Storage Blob Data Contributor" \
      --scope "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP/providers/Microsoft.Storage/storageAccounts/labamlwsstorageaccount"
    
    # Grant permission to create Compute in the Azure Machine Learning Workspace
    az role assignment create \
      --assignee-object-id $ENTRA_GROUP_OBJECT_ID \
      --assignee-principal-type Group \
      --role "Network Contributor" \
      --scope "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP/providers/Microsoft.Network/virtualNetworks/$VNET_NAME"
    
    # Grant permission to grant permission to see the Azure OpenAI Keys
    OPENAI_RESOURCE_ID=$(az cognitiveservices account show \
      --name "$OPENAI_RESOURCE_NAME" \
      --resource-group "$RESOURCE_GROUP" \
      --query id \
      -o tsv)
    
    az role assignment create \
      --assignee-object-id $ENTRA_GROUP_OBJECT_ID \
      --assignee-principal-type Group \
      --role "Cognitive Services User"\
      --scope "$OPENAI_RESOURCE_ID"
    </copy>
    ```

## Acknowledgements

* **Authors** - Rajib Sadhu
* **Source** - [Build a RAG App in 90 Minutes - Oracle AI Vector Search Meets Your Favorite LLM](https://docs.oracle.com/en/cloud/paas/multicloud/database-at-azure/latest/azlab/overview.html).
* **External assets** - Microsoft Azure interface screenshots and the referenced McAuley-Lab/Amazon-Reviews-2023 dataset material. Built with permission from the author(s).
* **Last Updated By/Date** - Rajib Sadhu, June 12, 2026
