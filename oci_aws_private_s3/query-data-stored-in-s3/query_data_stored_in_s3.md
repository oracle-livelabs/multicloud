# Query Data Stored in S3

## Introduction

In this module, you create a database credential, create an external table over the S3 CSV files, and query the data.

Estimated Time: 15 minutes

## Task 1: Create the S3 credential

In Database Actions SQL Studio, sign in as `ADMIN`. Copy **one complete SQL block at a time** into the worksheet, replace the indicated placeholders, and select **Run Script**. Do not paste the literal angle brackets (`<` and `>`) around a replacement value.

For this task, replace only these two placeholders with the restricted database-reader access key pair supplied for your lab:

- `<AWS_ACCESS_KEY_ID>`
- `<AWS_SECRET_ACCESS_KEY>`

```sql
BEGIN
  DBMS_CLOUD.CREATE_CREDENTIAL(
    credential_name => 'AWS_S3_CRED',
    username        => '<AWS_ACCESS_KEY_ID>',
    password        => '<AWS_SECRET_ACCESS_KEY>'
  );
END;
/
```

Do not use the AWS learner-console user credentials. Do not paste the key pair into Resource Manager, CloudFormation, or a source file.

## Task 2: Create the external table

Replace `<S3_BUCKET>` with the S3 bucket name supplied for your lab, then copy the entire block into SQL Studio and select **Run Script**.

```sql
BEGIN
  DBMS_CLOUD.CREATE_EXTERNAL_TABLE(
    table_name      => 'ORDERS_EXT',
    credential_name => 'AWS_S3_CRED',
    file_uri_list   => 'https://s3.us-east-1.amazonaws.com/<S3_BUCKET>/retail/orders_*.csv',
    column_list     => 'order_id NUMBER, order_date DATE, customer_id VARCHAR2(20), product_id VARCHAR2(20), product_category VARCHAR2(50), region VARCHAR2(30), quantity NUMBER, unit_price NUMBER, discount NUMBER, net_revenue NUMBER',
    format          => '{"type":"csv","skipheaders":"1","dateformat":"YYYY-MM-DD"}'
  );
END;
/
```

## Task 3: Validate and query

1. Replace `<S3_BUCKET>` with the same bucket name used in Task 2. Copy the complete query into SQL Studio and select **Run Statement**. Confirm that the private path can list S3 objects:

    ```sql
    SELECT *
    FROM DBMS_CLOUD.LIST_OBJECTS(
      credential_name => 'AWS_S3_CRED',
      location_uri    => 'https://s3.us-east-1.amazonaws.com/<S3_BUCKET>/retail/'
    );
    ```

2. Copy the complete query into SQL Studio and select **Run Statement**:

    ```sql
    SELECT COUNT(*) AS order_count,
           ROUND(SUM(net_revenue), 2) AS total_revenue
    FROM orders_ext;
    ```

    This query reads every CSV row exposed by the `ORDERS_EXT` external table. `COUNT(*)` returns the number of orders loaded from S3, and `SUM(net_revenue)` adds the `net_revenue` value from every order. `ROUND(..., 2)` formats the revenue total to two decimal places. A result confirms that Autonomous AI Lakehouse can read the S3 CSV data through the configured private path.

3. Expected result for the supplied sample files:

    | ORDER_COUNT | TOTAL_REVENUE |
    |---:|---:|
    | 8 | 3143.45 |

## Summary

You queried CSV data in Amazon S3 through the enforced private OCI--AWS path.
