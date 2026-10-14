# Overview

## About this workshop

In this workshop, you use Oracle--AWS Interconnect to give an Oracle Autonomous AI Lakehouse a private path to CSV data in Amazon S3. You then enforce private outbound routing from the lakehouse and query the S3 data through an external table.

The AWS and OCI event environments are prepared before the workshop. Learners verify the supplied foundations, create the cross-cloud interconnect, create their Autonomous AI Lakehouse, and run the database queries.

Estimated Workshop Time: 90 minutes

## Learning objectives

* Inspect the event AWS and OCI environments.
* Establish an Oracle--AWS Interconnect connection.
* Create an Autonomous AI Lakehouse with a private endpoint.
* Enforce private outbound connectivity from the database.
* Query private Amazon S3 CSV data with `DBMS_CLOUD`.

## Architecture

```text
Autonomous AI Lakehouse private endpoint
  -> OCI VCN -> DRG -> Oracle--AWS Interconnect
  -> AWS Direct Connect gateway -> VGW -> AWS VPC
  -> S3 Interface Endpoint -> Amazon S3 bucket
```

The S3 bucket policy accepts the database-reader identity only when S3 receives the request through the lab S3 Interface Endpoint. A successful query after private routing is enforced is the end-to-end validation.

## Workshop modules

1. Overview
2. Introduction
3. AWS Event Account
4. OCI Event Account
5. Verify AWS Lab Environment
6. Verify OCI Lab Environment
7. Create Oracle AWS Interconnect
8. Create Autonomous AI Lakehouse
9. Enforce Private Connection on Autonomous AI Lakehouse
10. Query Data Stored in S3

## Prerequisites

* Access to the assigned AWS event account in `us-east-1`.
* Access to the assigned OCI event account and lab compartment in `us-ashburn-1`.
* The handout values supplied by the instructor, including the AWS bucket name, Direct Connect gateway ID, OCI compartment OCID, and restricted AWS database-reader key pair.

## Acknowledgements

* **Author** - Arun Ramakrishnan
* **Last Updated By/Date** - David Start, October 2026
