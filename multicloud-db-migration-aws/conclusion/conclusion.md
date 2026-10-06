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

## Acknowledgements

* **Author** - Arnab Saha, Principal Solutions Architect, OCI Multicloud
* **Author** - Vineet Agarwal, Senior Principal Solutions Architect, OCI Multicloud
* **Last Updated By/Date** - Arnab Saha and Vineet Agarwal / September 30, 2026
