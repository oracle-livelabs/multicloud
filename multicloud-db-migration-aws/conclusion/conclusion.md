# Congratulations

## Introduction

You completed an online logical migration from a self-managed Oracle Database 19c on Amazon EC2 to Oracle Autonomous AI Database Serverless on Oracle AI Database@AWS.

### Objectives

* Review the completed migration workflow.
* Open the Oracle Zero Downtime Migration documentation for further learning.

Estimated Time: 5 minutes

## Task 1: Review What You Completed

1. Review the workshop outcomes and open the linked Oracle Zero Downtime Migration resource for further learning.

    In this workshop, you:

    * Verified the source database, target database, GoldenGate deployment, and shared Amazon EFS staging environment.

    * Confirmed the Data Pump initial-load path and the separate GoldenGate change-replication path.

    * Reviewed and evaluated the generated `ONLINE_LOGICAL` ZDM response file.

    * Started the migration and paused it after `ZDM_MONITOR_GG_LAG` with replication running.

    * Demonstrated committed source changes replicating to the target database.

    * Resumed the migration, completed the controlled cutover, and validated the target data.

## Learn More

* [Migrating with Zero Downtime Migration](https://docs.oracle.com/en/database/oracle/zero-downtime-migration/26.1/zdmug/migrating-with-zero-downtime-migration.html)
* [Oracle Zero Downtime Migration overview](https://www.oracle.com/database/zero-downtime-migration/)
* [ZDM CLI command reference](https://docs.oracle.com/en/database/oracle/zero-downtime-migration/26.1/zdmug/zero-downtime-migration-zdmcli-command-reference.html)
* [Logical migration response-file parameters](https://docs.oracle.com/en/database/oracle/zero-downtime-migration/26.1/zdmug/zero-downtime-migration-logical-migration-response-file-parameters-reference.html)
* [Non-interactive credentials using Oracle wallets](https://docs.oracle.com/en/database/oracle/zero-downtime-migration/26.1/zdmug/provide-passwords-non-interactively-using-wallet.html)

## Set Up in Your Own Environment

The participant environment is preconfigured. For your own AWS account and target database, use the following setup sequence with the linked Oracle documentation; the assigned lab scripts, passwords, resource IDs, and response file are not a deployment package for another account.

1. Plan the source database, target Autonomous AI Database, migration scope, and cutover window. Confirm supported versions and the prerequisites for online logical migration in the [ZDM migration guide](https://docs.oracle.com/en/database/oracle/zero-downtime-migration/26.1/zdmug/migrating-with-zero-downtime-migration.html).
2. Provision the source database EC2 host, ZDM service host, target database, Amazon EFS file system, and GoldenGate deployment. Plan routing, DNS, security groups, and private connectivity between these components. Use dedicated credentials and least-privilege access rather than the lab's shared passwords.
3. Install ZDM and configure SSH and the required sudo access to the source database host. Prepare source database logging, migration accounts, and the tables selected for migration according to the supported migration prerequisites.
4. Configure the target database accounts, client TLS wallet, and GoldenGate source database and target database connections. Verify authenticated connectivity from the components that will use each connection.
5. Mount Amazon EFS on the source database host, configure the target database EFS attachment and Data Pump directories, and verify that a file written from the target database is readable from the EC2 host.
6. Build a response file for your own resources using the [logical migration parameter reference](https://docs.oracle.com/en/database/oracle/zero-downtime-migration/26.1/zdmug/zero-downtime-migration-logical-migration-response-file-parameters-reference.html). Use `ONLINE_LOGICAL` and the protocol value `NFS` for Amazon EFS staging where applicable. Do not reuse lab hostnames, aliases, or wallet paths unchanged.
7. Run evaluation and resolve its findings. Then run the migration with a replication pause, validate committed source database changes on the target database, stop application writes, and resume for cutover. Validate the target database before switching application connections and planning cleanup.

This is a setup roadmap. Follow the product documentation for the installation and provisioning commands appropriate to your own topology.

## Acknowledgements

* **Author** - Arnab Saha, Principal Solutions Architect, OCI Multicloud
* **Author** - Vineet Agarwal, Senior Principal Solutions Architect, OCI Multicloud
* **Last Updated By/Date** - Arnab Saha and Vineet Agarwal / September 30, 2026
