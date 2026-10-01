# Create the Azure Storage Credential

## Introduction

Autonomous AI Database uses a database credential to authenticate to private objects in Azure Blob Storage. In this lab, you create or update `AZURE_BLOB_CRED` and verify that the database can list your workshop files. The same steps work with a provided environment or your own Azure resources.

Estimated Time: 10 minutes

### Objectives

In this lab, you will:

- Create or update a `DBMS_CLOUD` credential for Azure Blob Storage
- Verify access to the workshop container

## Task 1: Create or Update the Credential

1. In SQL Developer, open a worksheet for the `LAKE_DEMO` connection.

2. Locate the following values in your environment details. For a provided environment, use **View Login Info** or the values supplied by your facilitator. For your own environment, use the storage account, container, and access key from setup.

    | Value | What to enter |
    | --- | --- |
    | Storage account | `<storage-account-name>`, without a URL or `.blob.core.windows.net` |
    | Container | `<storage-container-name>`, without slashes |
    | Storage access key | `<azure-storage-access-key>` for that storage account |

    The container must contain `data/customer.csv`, files under `data/custsales/`, and `data/movies.json`. Use the storage access key, not your Azure sign-in or virtual machine password.

3. Use **Run Script (F5)** to run the following block. Enter the requested names and key at the prompts. The key prompt is hidden, and substitution values are not echoed to Script Output. Keep keys out of saved scripts and screenshots.

    Setup for your own account may already have created `AZURE_BLOB_CRED` while loading the reference tables. This block updates that credential in place if it exists; it creates the credential if it is absent.

    ```sql
    SET DEFINE ON
    SET VERIFY OFF
    SET ECHO OFF
    ACCEPT storage_account CHAR PROMPT 'Azure Storage account name: '
    ACCEPT storage_container CHAR PROMPT 'Azure Storage container name: '
    ACCEPT azure_storage_key CHAR PROMPT 'Azure Storage access key: ' HIDE

    DECLARE
      l_exists      PLS_INTEGER;
      l_account     VARCHAR2(128) := '&storage_account';
      l_access_key  VARCHAR2(4000) := '&azure_storage_key';
    BEGIN
      SELECT COUNT(*) INTO l_exists
      FROM user_credentials
      WHERE credential_name = 'AZURE_BLOB_CRED';

      IF l_exists = 0 THEN
        DBMS_CLOUD.CREATE_CREDENTIAL(
          credential_name => 'AZURE_BLOB_CRED',
          username        => l_account,
          password        => l_access_key
        );
      ELSE
        DBMS_CLOUD.UPDATE_CREDENTIAL(
          credential_name => 'AZURE_BLOB_CRED',
          attribute       => 'USERNAME',
          value           => l_account
        );
        DBMS_CLOUD.UPDATE_CREDENTIAL(
          credential_name => 'AZURE_BLOB_CRED',
          attribute       => 'PASSWORD',
          value           => l_access_key
        );
      END IF;
    END;
    /
    UNDEFINE azure_storage_key
    ```

4. Confirm that the block completes successfully, then check the stored account name without displaying the key:

    ```sql
    SELECT credential_name, username
    FROM user_credentials
    WHERE credential_name = 'AZURE_BLOB_CRED';
    ```

## Task 2: Verify Access to Azure Blob Storage

1. In the same worksheet, use **Run Script (F5)** to query your container. The substitution variables contain the account and container entered in Task 1.

    ```sql
    SELECT object_name, bytes
    FROM DBMS_CLOUD.LIST_OBJECTS(
      credential_name => 'AZURE_BLOB_CRED',
      location_uri    => 'https://&storage_account..blob.core.windows.net/&storage_container./'
    )
    ORDER BY object_name;
    ```

2. Confirm that the results include `data/customer.csv`, files under `data/custsales/`, and `data/movies.json`. Keep the same account and container names for the next lab.

3. If the query returns an authentication error, confirm that the key belongs to the selected storage account and rerun Task 1 with the correct values. If files are missing, verify the container and the `data/` prefix against your setup. Continue only after the listing succeeds.

## Learn More

- [DBMS_CLOUD credential procedures](https://docs.oracle.com/en/cloud/paas/autonomous-database/serverless/adbsb/dbms-cloud-subprograms.html)

## Acknowledgements

- **Author** - Oracle Multicloud Team
- **Last Updated By/Date** - Oracle LiveLabs, September 2026
