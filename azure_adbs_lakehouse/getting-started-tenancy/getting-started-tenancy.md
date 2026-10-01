# Get Started with Your Azure Environment

## Introduction

In this lab, you prepare the resources for the Lakehouse workshop in your own Azure subscription. You create the network, a Windows virtual machine, Azure Blob Storage with the MovieStream sample data, an Autonomous AI Database, and an Azure OpenAI deployment. You also create the `LAKE_DEMO` schema and load its three reference tables before joining the shared workshop labs.

Estimated Time: 60 minutes, plus resource provisioning time

### Objectives

In this lab, you will:

- Create the Azure resources used by the workshop
- Import the sample files and prepare the `LAKE_DEMO` schema
- Record the connection details needed for Labs 1 through 5
- Connect to the Windows virtual machine and install SQL Developer

### Prerequisites

This track uses your own subscription and creates billable resources. Before starting, you need:

- An Azure subscription with [Oracle AI Database@Azure onboarding completed](https://docs.oracle.com/en-us/iaas/Content/database-at-azure/oaaonboard.htm), including its linked OCI account and the required resource provider registrations
- Permission to create resource groups, networks, Windows virtual machines, storage accounts, Oracle Autonomous AI Databases, and Microsoft Foundry resources, and to retrieve storage and Azure OpenAI access keys
- An eligible Oracle license for the `BringYourOwnLicense` configuration used in this guide
- Capacity for a `Standard_D2s_v5` Windows virtual machine, a 2-ECPU Autonomous AI Database, and the Azure OpenAI deployment in your selected region
- A Remote Desktop client and your computer's current public IPv4 address

The commands use `eastus` as the starting region. Use a region supported by your Oracle AI Database@Azure subscription and Azure OpenAI quota. Review the [Oracle provisioning prerequisites](https://docs.oracle.com/en-us/iaas/Content/database-at-azure/azucr-create-prerequisites.html) if your subscription has not provisioned a database before.

## Task 1: Set Up Your Environment

1. Sign in to the [Azure portal](https://portal.azure.com) with your own account. Open **Cloud Shell** and select **Bash**. Run the setup commands in Cloud Shell; PowerShell inside the Windows virtual machine is used later to install SQL Developer.

    Keep this Cloud Shell session open throughout setup. When you create passwords, save them in your password manager. The later labs require the Windows password, database `ADMIN` password, and `LAKE_DEMO` password.

2. Select your subscription and define the lab resource names. When prompted for the RDP source IP, enter **your computer's public IPv4 address**, followed by `/32`. Obtain this address from your network administrator or your organization's approved IP lookup tool. Do not enter a private address such as `192.168.x.x` or the Cloud Shell address.

    This block creates unique names on its first run and saves nonsecret settings in `$HOME/lakehouse-lab.env`. Running it again loads those same settings. If Cloud Shell reconnects, run this block again before continuing. If you use Cloud Shell without persistent storage, download this environment file before closing the session and upload it when you return. It contains resource names and settings, not passwords or keys.

    ```bash
    <copy>
    if [[ -f "$HOME/lakehouse-lab.env" ]]; then
      source "$HOME/lakehouse-lab.env"
    else
      read -r -p 'Azure subscription ID or name: ' AZURE_SUBSCRIPTION
      read -r -p 'Your computer public IPv4 address with /32: ' RDP_SOURCE_CIDR
      LAB_SUFFIX="$(openssl rand -hex 4)"
      RESOURCE_GROUP="rg-lakehouse-${LAB_SUFFIX}"
      LOCATION="eastus"
      VNET_NAME="vnet-lakehouse-${LAB_SUFFIX}"
      ADDRESS_PREFIX="10.100.0.0/16"
      PUBLIC_SUBNET="lab-lakehouse-subnet"
      PUBLIC_PREFIX="10.100.0.0/24"
      DELEGATED_SUBNET_NAME="lab-lakehouse-delsubnet"
      DELEGATED_SUBNET_PREFIX="10.100.1.0/24"
      VM_NAME="host-lakehouse-${LAB_SUFFIX}"
      ADMIN_USER="azureuser"
      NSG_NAME="nsg-lakehouse-${LAB_SUFFIX}"
      STORAGE_ACCOUNT="lakehouse${LAB_SUFFIX}"
      CONTAINER="lakehouse-data"
      ADBS_NAME="adbs${LAB_SUFFIX}"
      FOUNDRY_RESOURCE_NAME="lakehouse-ai-${LAB_SUFFIX}"
      PROJECT_NAME="default"
      DEPLOYMENT_NAME="lablakehouse-nlp"
      MODEL_NAME="gpt-5.4-mini"
      DEPLOYMENT_SKU="GlobalStandard"
      CAPACITY=1
      umask 077
      declare -p AZURE_SUBSCRIPTION RDP_SOURCE_CIDR LAB_SUFFIX RESOURCE_GROUP \
        LOCATION VNET_NAME ADDRESS_PREFIX PUBLIC_SUBNET PUBLIC_PREFIX \
        DELEGATED_SUBNET_NAME DELEGATED_SUBNET_PREFIX VM_NAME ADMIN_USER \
        NSG_NAME STORAGE_ACCOUNT CONTAINER ADBS_NAME FOUNDRY_RESOURCE_NAME \
        PROJECT_NAME DEPLOYMENT_NAME MODEL_NAME DEPLOYMENT_SKU CAPACITY \
        > "$HOME/lakehouse-lab.env"
    fi
    az account set --subscription "$AZURE_SUBSCRIPTION"
    az account show --query '{subscription:name,id:id}' --output table
    printf 'Lab resource group: %s\nRegion: %s\n' "$RESOURCE_GROUP" "$LOCATION"
    </copy>
    ```

    Confirm that the displayed subscription is the one you intend to use. If you need a different region or RDP address, edit `lakehouse-lab.env` in the Cloud Shell editor and load it with `source "$HOME/lakehouse-lab.env"` before creating resources.

3. Create the resource group, virtual network, Windows access subnet, and delegated subnet.

    ```bash
    <copy>
    (
      set -euo pipefail
      az group create --name "$RESOURCE_GROUP" --location "$LOCATION" --output table

      az network vnet create \
        --resource-group "$RESOURCE_GROUP" \
        --name "$VNET_NAME" \
        --location "$LOCATION" \
        --address-prefixes "$ADDRESS_PREFIX" \
        --subnet-name "$PUBLIC_SUBNET" \
        --subnet-prefixes "$PUBLIC_PREFIX" \
        --output table

      az network vnet subnet create \
        --resource-group "$RESOURCE_GROUP" \
        --vnet-name "$VNET_NAME" \
        --name "$DELEGATED_SUBNET_NAME" \
        --address-prefixes "$DELEGATED_SUBNET_PREFIX" \
        --delegations 'Oracle.Database/networkAttachments' \
        --output table

      az network vnet subnet list \
        --resource-group "$RESOURCE_GROUP" \
        --vnet-name "$VNET_NAME" \
        --query '[].{name:name,prefix:addressPrefix,delegations:delegations[].serviceName}' \
        --output table
    )
    </copy>
    ```

    Confirm that both subnets appear and that the delegated subnet lists `Oracle.Database/networkAttachments`.

4. Create the Windows virtual machine. The network security group allows inbound RDP only from the `/32` address you entered. Choose a new Windows administrator password with 12–30 characters, including uppercase letters, lowercase letters, numbers, and a symbol. Do not include `azureuser` in the password.

    ```bash
    <copy>
    (
      set -euo pipefail
      python3 - "$RDP_SOURCE_CIDR" <<'PY'
    import ipaddress, sys
    network = ipaddress.ip_network(sys.argv[1], strict=True)
    if network.version != 4 or network.prefixlen != 32 or not network.network_address.is_global:
        raise SystemExit('Enter your computer public IPv4 address followed by /32 before continuing.')
    PY
      read -r -s -p 'Choose the Windows azureuser password: ' VM_ADMIN_PASSWORD
      printf '\n'
      trap 'unset VM_ADMIN_PASSWORD' EXIT
      SUBNET_ID="$(az network vnet subnet show \
        --resource-group "$RESOURCE_GROUP" --vnet-name "$VNET_NAME" \
        --name "$PUBLIC_SUBNET" --query id --output tsv)"

      az network nsg create \
        --resource-group "$RESOURCE_GROUP" --name "$NSG_NAME" \
        --location "$LOCATION" --output table
      az network nsg rule create \
        --resource-group "$RESOURCE_GROUP" --nsg-name "$NSG_NAME" \
        --name AllowRdpFromParticipant --priority 1000 \
        --direction Inbound --access Allow --protocol Tcp \
        --source-address-prefixes "$RDP_SOURCE_CIDR" --source-port-ranges '*' \
        --destination-address-prefixes '*' --destination-port-ranges 3389 \
        --output table

      az vm create \
        --resource-group "$RESOURCE_GROUP" \
        --name "$VM_NAME" \
        --location "$LOCATION" \
        --image 'MicrosoftWindowsDesktop:windows-11:win11-24h2-ent:latest' \
        --size Standard_D2s_v5 \
        --admin-username "$ADMIN_USER" \
        --admin-password "$VM_ADMIN_PASSWORD" \
        --subnet "$SUBNET_ID" \
        --public-ip-sku Standard \
        --public-ip-address-allocation static \
        --nsg "$NSG_NAME" \
        --nsg-rule NONE \
        --output table
    )
    </copy>
    ```

    Wait for VM creation to finish. You will connect to this machine in **Task 3**. If your computer's public IP changes later, update the `AllowRdpFromParticipant` rule to your new `/32` address before reconnecting.

5. Create the storage account, then import the sample data. The storage account name must be globally unique; the generated suffix helps avoid collisions.

    ```bash
    <copy>
    az storage account create \
      --name "$STORAGE_ACCOUNT" \
      --resource-group "$RESOURCE_GROUP" \
      --location "$LOCATION" \
      --sku Standard_LRS \
      --kind StorageV2 \
      --min-tls-version TLS1_2 \
      --https-only true \
      --allow-blob-public-access false \
      --output table
    </copy>
    ```

    [Download the setup scripts](files/lakehouse-setup.zip). In Cloud Shell, use **Manage files > Upload** to upload `lakehouse-setup.zip`, then run:

    ```bash
    <copy>
    mkdir -p "$HOME/lakehouse-scripts"
    unzip -o "$HOME/lakehouse-setup.zip" -d "$HOME/lakehouse-scripts"
    bash "$HOME/lakehouse-scripts/import-sample-data.sh" \
      "$RESOURCE_GROUP" "$STORAGE_ACCOUNT" "$CONTAINER"
    </copy>
    ```

    The script creates a private `lakehouse-data` container. It copies the public Oracle MovieStream objects into these paths:

    - `data/customer.csv`
    - `data/customer_segment.csv`
    - `data/customer-extension.csv`
    - `data/genre.csv`
    - `data/movies.json`
    - `data/custsales/`, preserving all folders below that prefix

    Wait for the upload to finish and review the listed blobs. The `data/custsales/` folder contains multiple files; importing only one sales file would give incomplete query results. If an upload fails, resolve the reported error and run the import script again. It replaces the sample blobs with the same source data.

6. Create the Autonomous AI Database. Use public access with an access list limited to the Windows VM and your current Cloud Shell session. The Cloud Shell address is detected by an HTTPS request to an IP-echo endpoint; no credentials are sent to that endpoint.

    Choose an `ADMIN` password with 12–30 characters from letters, numbers, `_`, `#`, `!`, and `-`, including uppercase, lowercase, and a number. Do not include `ADMIN`. The provisioning script uses the same supported character set when it prompts for this password again.

    ```bash
    <copy>
    (
      set -euo pipefail
      az extension add --name oracle-database --upgrade
      VM_PUBLIC_IP="$(az vm show --show-details \
        --resource-group "$RESOURCE_GROUP" --name "$VM_NAME" \
        --query publicIps --output tsv)"
      CLOUD_SHELL_IP="$(curl -4 --fail --silent --show-error https://checkip.amazonaws.com)"
      ALLOWED_PUBLIC_IPS="$(python3 - "$VM_PUBLIC_IP" "$CLOUD_SHELL_IP" <<'PY'
    import ipaddress, json, sys
    addresses = [ipaddress.ip_address(value.strip()) for value in sys.argv[1:]]
    if any(address.version != 4 or not address.is_global for address in addresses):
        raise SystemExit('Could not determine the VM and Cloud Shell public IPv4 addresses.')
    print(json.dumps([f'{address}/32' for address in addresses]))
    PY
      )"
      read -r -s -p 'Choose the database ADMIN password: ' ADB_ADMIN_PASSWORD
      printf '\n'
      trap 'unset ADB_ADMIN_PASSWORD' EXIT
      if [[ ! "$ADB_ADMIN_PASSWORD" =~ ^[A-Za-z0-9_#!-]{12,30}$ || ! "$ADB_ADMIN_PASSWORD" =~ [A-Z] || ! "$ADB_ADMIN_PASSWORD" =~ [a-z] || ! "$ADB_ADMIN_PASSWORD" =~ [0-9] ]]; then
        echo 'Use the password format described above and run this step again.' >&2
        exit 1
      fi

      az oracle-database autonomous-database create \
        --resource-group "$RESOURCE_GROUP" \
        --location "$LOCATION" \
        --autonomousdatabasename "$ADBS_NAME" \
        --display-name "$ADBS_NAME" \
        --admin-password "$ADB_ADMIN_PASSWORD" \
        --compute-model ECPU \
        --compute-count 2 \
        --data-storage-size-in-tbs 1 \
        --license-model BringYourOwnLicense \
        --db-workload DW \
        --db-version 26ai \
        --character-set AL32UTF8 \
        --ncharacter-set AL16UTF16 \
        --is-mtls-connection-required false \
        --whitelisted-ips "$ALLOWED_PUBLIC_IPS" \
        --regular \
        --output table

      az oracle-database autonomous-database show \
        --resource-group "$RESOURCE_GROUP" --autonomousdatabasename "$ADBS_NAME" \
        --query '{name:name,provisioning:properties.provisioningState,lifecycle:properties.lifecycleState}' \
        --output table
    )
    </copy>
    ```

    Continue when the database is available. If the command reports a quota, region, license, or onboarding error, resolve it before proceeding. The [Azure CLI database reference](https://learn.microsoft.com/en-us/cli/azure/oracle-database/autonomous-database?view=azure-cli-latest) describes the creation and wallet options.

7. Prepare the `LAKE_DEMO` schema and load the reference tables. Keep the same Cloud Shell session so its IP still matches the database access list. The script prompts for the existing database `ADMIN` password, a new `LAKE_DEMO` password, and a wallet password. Use the same password character set described in the previous step. Keep the `LAKE_DEMO` password for **Lab 1**.

    ```bash
    <copy>
    bash "$HOME/lakehouse-scripts/provision-lake-demo.sh" \
      "$RESOURCE_GROUP" "$ADBS_NAME" "$STORAGE_ACCOUNT" "$CONTAINER"
    </copy>
    ```

    The script downloads SQLcl and the database wallet, creates `LAKE_DEMO`, grants the lab privileges, enables its REST schema, creates `AZURE_BLOB_CRED`, and loads `GENRE`, `CUSTOMER_EXTENSION`, and `CUSTOMER_SEGMENT`. It finishes by displaying the row counts. Continue only after all three counts are greater than zero.

    The script stops if `LAKE_DEMO` already exists so an existing schema is not overwritten. If an error occurs after the schema is created, review the error and the partial schema before retrying. Use a new dedicated lab database if you need to start over. **Lab 2** refreshes the existing Azure credential, and **Lab 3** creates the external tables and views that use the uploaded files.

    If Cloud Shell has restarted and the SQLcl connection times out, find its current public IPv4 address again and replace the old Cloud Shell `/32` entry in the database's network access list. Keep the VM `/32` entry. Do not open access to all IP addresses.

8. Create the Microsoft Foundry resource and deploy the Azure OpenAI model.

    ```bash
    <copy>
    (
      set -euo pipefail
      az cognitiveservices account create \
        --name "$FOUNDRY_RESOURCE_NAME" \
        --resource-group "$RESOURCE_GROUP" \
        --location "$LOCATION" \
        --kind AIServices \
        --sku S0 \
        --custom-domain "$FOUNDRY_RESOURCE_NAME" \
        --assign-identity \
        --allow-project-management true \
        --yes \
        --output table

      az cognitiveservices account project create \
        --name "$FOUNDRY_RESOURCE_NAME" \
        --resource-group "$RESOURCE_GROUP" \
        --project-name "$PROJECT_NAME" \
        --location "$LOCATION" \
        --output table

      MODEL_VERSION="$(az cognitiveservices account list-models \
        --name "$FOUNDRY_RESOURCE_NAME" \
        --resource-group "$RESOURCE_GROUP" \
        --query "sort_by([?name=='${MODEL_NAME}' && format=='OpenAI'], &version)[-1].version" \
        --output tsv)"

      if [[ -z "$MODEL_VERSION" || "$MODEL_VERSION" == None ]]; then
        echo "Model $MODEL_NAME is unavailable in $LOCATION. Review these available models and your quota before proceeding."
        az cognitiveservices account list-models \
          --name "$FOUNDRY_RESOURCE_NAME" --resource-group "$RESOURCE_GROUP" \
          --query "[?format=='OpenAI'].{model:name,version:version}" --output table
        exit 1
      fi

      az cognitiveservices account deployment create \
        --name "$FOUNDRY_RESOURCE_NAME" \
        --resource-group "$RESOURCE_GROUP" \
        --deployment-name "$DEPLOYMENT_NAME" \
        --model-name "$MODEL_NAME" \
        --model-version "$MODEL_VERSION" \
        --model-format OpenAI \
        --sku-name "$DEPLOYMENT_SKU" \
        --sku-capacity "$CAPACITY" \
        --output table

      az cognitiveservices account deployment show \
        --name "$FOUNDRY_RESOURCE_NAME" --resource-group "$RESOURCE_GROUP" \
        --deployment-name "$DEPLOYMENT_NAME" \
        --query '{name:name,state:properties.provisioningState,model:properties.model.name}' \
        --output table
    )
    </copy>
    ```

    This workshop uses `gpt-5.4-mini`. Model availability, versions, and quota depend on your subscription and region. If this model is unavailable, select a supported chat model with your workshop administrator, update `MODEL_NAME` in `lakehouse-lab.env`, reload the settings, and repeat this step. Continue only when the deployment succeeds. Keep the deployment name `lablakehouse-nlp`, or record the replacement name for **Lab 4**.

## Task 2: Record Your Lab Connection Details

1. Display and record the nonsecret resource values. Use your own names wherever the shared labs show an event example or an angle-bracket placeholder.

    ```bash
    <copy>
    printf 'Resource group: %s\nWindows VM: %s\nWindows user: %s\nDatabase: %s\nDatabase user: LAKE_DEMO\nStorage account: %s\nStorage container: %s\nAzure OpenAI resource: %s\nAzure OpenAI deployment: %s\n' \
      "$RESOURCE_GROUP" "$VM_NAME" "$ADMIN_USER" "$ADBS_NAME" \
      "$STORAGE_ACCOUNT" "$CONTAINER" "$FOUNDRY_RESOURCE_NAME" "$DEPLOYMENT_NAME"
    az cognitiveservices account show \
      --name "$FOUNDRY_RESOURCE_NAME" --resource-group "$RESOURCE_GROUP" \
      --query properties.endpoint --output tsv
    </copy>
    ```

    | Value used in the shared labs | Value from this setup |
    | --- | --- |
    | `<database-name>` | `ADBS_NAME` |
    | Database user | `LAKE_DEMO` |
    | Database user password | The `LAKE_DEMO` password entered during schema preparation |
    | `<storage-account-name>` | `STORAGE_ACCOUNT` |
    | `<storage-container-name>` | `CONTAINER`, normally `lakehouse-data` |
    | `<azure-openai-resource-name>` | `FOUNDRY_RESOURCE_NAME` |
    | `<azure-openai-deployment-name>` | `DEPLOYMENT_NAME`, normally `lablakehouse-nlp` |

2. In the Azure portal, open your storage account and locate **Access keys**. Keep the key available for `<azure-storage-access-key>` in **Lab 2**. Open the Foundry resource and locate **Keys and Endpoint**; keep an Azure OpenAI key available for `<azure-openai-api-key>` in **Lab 4**. Store keys with your passwords rather than in the nonsecret environment file.

3. Download [install-sql-developer.ps1](files/install-sql-developer.ps1), or keep its link available. After connecting to the Windows VM in the next task, run its commands in **PowerShell inside that VM**. It downloads SQL Developer 26.2 with JDK 17, extracts it to `C:\software\sqldeveloper`, and starts SQL Developer. Do not run this PowerShell script in Cloud Shell.

## Task 3: Connect to the Windows Virtual Machine

[](include:connect-windows)

## Acknowledgements

- **Author** - Oracle Multicloud Team
- **Last Updated By/Date** - Oracle LiveLabs, September 2026
