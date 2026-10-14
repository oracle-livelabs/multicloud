# Enforce Private Connection on Autonomous AI Lakehouse

## Introduction

In this module, you require the Autonomous AI Lakehouse to use its private endpoint for outbound connections.

Estimated Time: 5 minutes

## Task 1: Enforce private outbound routing

1. In **Database Actions**, open an SQL worksheet as `ADMIN`.
2. Copy the following complete statement and paste it into the worksheet. It requires no edits or placeholder values. Include the trailing semicolon, then click **Run Statement**.

    ```sql
    ALTER DATABASE PROPERTY SET ROUTE_OUTBOUND_CONNECTIONS = 'ENFORCE_PRIVATE_ENDPOINT';
    ```

3. After the statement succeeds, copy and run this verification query:

    ```sql
    SELECT property_name, property_value FROM database_properties WHERE property_name = 'ROUTE_OUTBOUND_CONNECTIONS';
    ```

4. Confirm that the value is `ENFORCE_PRIVATE_ENDPOINT`.

## Why this matters

The next module contacts S3 using its normal regional hostname. OCI DNS forwards the S3 lookup to the AWS Resolver endpoint, and traffic uses the Autonomous AI Lakehouse private endpoint, OCI DRG, Oracle--AWS Interconnect, and the AWS S3 Interface Endpoint. The S3 bucket policy rejects the database-reader identity outside that endpoint.

## Summary

Private outbound routing is enforced for the Autonomous AI Lakehouse.
