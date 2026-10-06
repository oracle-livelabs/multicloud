# Introduction

## Introduction

**In this workshop, you perform an online logical migration from a self-managed Oracle Database 19c on Amazon EC2 to Oracle Autonomous AI Database Serverless on Oracle AI Database@AWS.**

Oracle Zero Downtime Migration (ZDM) orchestrates the migration of `FINANCE.ACCOUNTS`. Oracle Data Pump performs the initial load through shared Amazon EFS, while Oracle GoldenGate captures and applies subsequent source changes. EFS carries the Data Pump dump set, not the GoldenGate change stream.

The source can accept writes during initial load and replication. Controlled cutover still requires stopping source application writes, letting replication catch up, and validating the target before redirecting the application.

![Online logical migration with Data Pump initial load, GoldenGate replication, and ZDM orchestration](./images/zdm-online-architecture.png)

### Objectives

- Explain how ZDM orchestrates the online logical migration.
- Distinguish the Data Pump initial-load path from the GoldenGate change-replication path.
- Describe the role of shared Amazon EFS in the migration.
- Explain why application writes must stop during controlled cutover.

Estimated Workshop Time: 90 minutes, excluding instructor provisioning. Actual timings depend on the environment.

For product behavior beyond this lab, see the [ZDM 26.1 migration guide](https://docs.oracle.com/en/database/oracle/zero-downtime-migration/26.1/zdmug/migrating-with-zero-downtime-migration.html).

## Acknowledgements

* **Author** - Arnab Saha, Principal Solutions Architect, OCI Multicloud
* **Author** - Vineet Agarwal, Senior Principal Solutions Architect, OCI Multicloud
* **Last Updated By/Date** - Arnab Saha and Vineet Agarwal / September 30, 2026
