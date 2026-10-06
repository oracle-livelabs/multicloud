# Overview

## Introduction

**Migrate an Oracle Database on Amazon EC2 to Oracle Autonomous AI Database Serverless with minimal downtime.**

In this 90-minute hands-on workshop, you use Oracle Zero Downtime Migration (ZDM), Oracle Data Pump, Oracle GoldenGate, and Amazon Elastic File System (EFS) to perform an online logical migration from a self-managed Oracle Database 19c on Amazon EC2 to Oracle Autonomous AI Database Serverless on Oracle AI Database@AWS.

By the end of the workshop, you will have evaluated the migration configuration, completed the initial data load, verified ongoing change replication, and performed a controlled cutover.

### Objectives

- Verify the source, target, GoldenGate, and shared NFS staging environment.
- Evaluate the generated `ONLINE_LOGICAL` response file.
- Run ZDM with a pause after `ZDM_MONITOR_GG_LAG`.
- Demonstrate committed changes replicating to the target.
- Validate the migrated data and perform an instructor-approved cutover.

Estimated Workshop Time: 90 minutes, excluding instructor provisioning. Actual timings depend on the environment.

### Prerequisites and Responsibilities

Your assigned EC2 instance, target database, EFS, GoldenGate deployment, wallet, and SSH access are already configured. Use only your assigned resources. Obtain your Lab ID, EC2 instance ID, AWS sign-in details, and database passwords through the workshop credential process before starting.

Use the generated `/data/oracle/lab/config/lab-env.sh` and `zdm-response-online.rsp`. The source SID and service are `SOURCE19C`, and the migration scope is `FINANCE.ACCOUNTS`.

Participant SQL connections use password-authenticated TLS on port 1521. ZDM uses the assigned target wallet and wallet service alias on TCPS port 1522. Do not replace one configuration with the other. Keep credentials and wallet contents out of this repository.

### Workshop Flow

1. Confirm the migration architecture and complete the preflight checks — 15 minutes.
2. Verify shared Amazon EFS NFS staging — 15 minutes.
3. Review the configuration and evaluate the online migration — 20 minutes.
4. Execute, monitor, validate, and complete the online migration — 40 minutes.

## Acknowledgements

* **Author** - Arnab Saha, Principal Solutions Architect, OCI Multicloud
* **Author** - Vineet Agarwal, Senior Principal Solutions Architect, OCI Multicloud
* **Last Updated By/Date** - Arnab Saha and Vineet Agarwal / September 30, 2026
