# Configure Select AI with Azure OpenAI

## Introduction

In this lab, you allow the `LAKE_DEMO` schema to call your Azure OpenAI resource, store its API key in a database credential, and create a Select AI profile restricted to the workshop objects. Use the resource and deployment assigned to you or created during your own-account setup.

Estimated Time: 10 minutes

### Objectives

In this lab, you will:

- Grant outbound HTTP access to the Azure OpenAI host
- Create or update an Azure OpenAI credential
- Create a governed Select AI profile

## Task 1: Allow Access to Azure OpenAI

1. In SQL Developer, open a worksheet for the `ADMIN` connection.

2. Locate the Azure OpenAI resource name, deployment name, and API key in your environment details. Use the resource **name**, such as the value before `.openai.azure.com`, rather than its endpoint URL. The deployment name is the name assigned when the model was deployed; it can differ from the model name.

3. Use **Run Script (F5)** to enter `<azure-openai-resource-name>` and allow the `LAKE_DEMO` schema to call its host:

    ```sql
    SET DEFINE ON
    SET VERIFY OFF
    ACCEPT azure_resource_name CHAR PROMPT 'Azure OpenAI resource name: '

    BEGIN
      DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE(
        host => '&azure_resource_name..openai.azure.com',
        ace  => xs$ace_type(
          privilege_list => xs$name_list('http'),
          principal_name => 'LAKE_DEMO',
          principal_type => xs_acl.ptype_db
        )
      );
    END;
    /
    ```

## Task 2: Create or Update the Azure OpenAI Credential

1. Open a worksheet for the `LAKE_DEMO` connection.

2. For a provided environment, obtain `<azure-openai-api-key>` from **View Login Info** or your facilitator. For your own environment, use a key for the Azure OpenAI resource you created. Keep the key out of saved scripts and screenshots.

3. Use **Run Script (F5)**. Enter the same resource name used in Task 1, your `<azure-openai-deployment-name>`, and the API key. The key prompt is hidden. This block creates the credential if it is absent or updates it in place if you are repeating the lab.

    ```sql
    SET DEFINE ON
    SET VERIFY OFF
    SET ECHO OFF
    ACCEPT azure_resource_name CHAR PROMPT 'Azure OpenAI resource name: '
    ACCEPT azure_deployment_name CHAR PROMPT 'Azure OpenAI deployment name: '
    ACCEPT azure_openai_key CHAR PROMPT 'Azure OpenAI API key: ' HIDE

    DECLARE
      l_exists        PLS_INTEGER;
      l_resource_name VARCHAR2(128) := '&azure_resource_name';
      l_api_key       VARCHAR2(4000) := '&azure_openai_key';
    BEGIN
      SELECT COUNT(*) INTO l_exists
      FROM user_credentials
      WHERE credential_name = 'AZURE_OPENAI_CRED';

      IF l_exists = 0 THEN
        DBMS_CLOUD.CREATE_CREDENTIAL(
          credential_name => 'AZURE_OPENAI_CRED',
          username        => l_resource_name,
          password        => l_api_key
        );
      ELSE
        DBMS_CLOUD.UPDATE_CREDENTIAL(
          credential_name => 'AZURE_OPENAI_CRED',
          attribute       => 'USERNAME',
          value           => l_resource_name
        );
        DBMS_CLOUD.UPDATE_CREDENTIAL(
          credential_name => 'AZURE_OPENAI_CRED',
          attribute       => 'PASSWORD',
          value           => l_api_key
        );
      END IF;
    END;
    /
    UNDEFINE azure_openai_key
    ```

4. Confirm that the block completes successfully. Keep this `LAKE_DEMO` worksheet open for Tasks 3 and 4 so the resource and deployment variables remain available.

## Task 3: Verify the Approved Objects

The profile includes the external objects you created and three reference tables prepared during setup: `CUSTOMER_EXTENSION`, `CUSTOMER_SEGMENT`, and `GENRE`.

1. Run the following query:

    ```sql
    SELECT table_name
    FROM user_tables
    WHERE table_name IN (
      'CUSTOMER_EXT',
      'CUSTOMER_EXTENSION',
      'CUST_SALES_EXT',
      'CUSTOMER_SEGMENT',
      'GENRE'
    )
    UNION ALL
    SELECT view_name
    FROM user_views
    WHERE view_name IN (
      'MOVIES_EXT',
      'MOVIES_BY_GENRE'
    )
    ORDER BY 1;
    ```

2. Confirm that the query returns all seven object names. If a reference table is missing, verify that you connected to the correct database and completed your setup path. For a provided environment, ask your facilitator to check the assigned database. Continue only when all seven objects are available.

## Task 4: Create the Select AI Profile

1. In the same `LAKE_DEMO` worksheet, use **Run Script (F5)** to create the profile with the resource and deployment names entered in Task 2. The ACL host, API key, and profile must refer to the same Azure OpenAI resource.

    ```sql
    BEGIN
      DBMS_CLOUD_AI.CREATE_PROFILE(
        profile_name => 'LAKEHOUSE_AZURE_OPENAI',
        attributes   => q'~{
          "provider": "azure",
          "azure_resource_name": "&azure_resource_name",
          "azure_deployment_name": "&azure_deployment_name",
          "credential_name": "AZURE_OPENAI_CRED",
          "object_list": [
            {"owner": "LAKE_DEMO", "name": "CUSTOMER_EXT"},
            {"owner": "LAKE_DEMO", "name": "CUSTOMER_EXTENSION"},
            {"owner": "LAKE_DEMO", "name": "CUST_SALES_EXT"},
            {"owner": "LAKE_DEMO", "name": "CUSTOMER_SEGMENT"},
            {"owner": "LAKE_DEMO", "name": "GENRE"},
            {"owner": "LAKE_DEMO", "name": "MOVIES_EXT"},
            {"owner": "LAKE_DEMO", "name": "MOVIES_BY_GENRE"}
          ],
          "enforce_object_list": true,
          "comments": true,
          "additional_instructions": "Generate read-only Oracle SQL using only the allow-listed objects. Never generate DDL, DML, PL/SQL, or package calls."
        }~'
      );
    END;
    /
    ```

2. Confirm that the block completes successfully.

## Learn More

- [DBMS_CLOUD_AI profile attributes](https://docs.oracle.com/en/database/oracle/oracle-database/19/arpls/dbms_cloud_ai1.html)

## Acknowledgements

- **Author** - Oracle Multicloud Team
- **Last Updated By/Date** - Oracle LiveLabs, September 2026
